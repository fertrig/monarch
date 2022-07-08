import 'package:monarch_cli/src/task_runner/task.dart';
import 'package:monarch_grpc/monarch_grpc.dart';
import 'package:monarch_utils/log.dart';

import 'grpc.dart';
import 'reload.dart';
import 'process_task.dart';
import '../utils/standard_output.dart' show StandardOutput;
import 'task_count_heartbeat.dart';

abstract class TasksManager {
  void manage();
  bool get isRunning;
}

abstract class RegenAndReload implements TasksManager {
  String get heartbeatMessage;
  void requestReload();

  final StandardOutput stdout_;

  /// The "watch-to-regen-meta-stories" task.
  final ProcessParentReadyTask regenTask;

  /// The "attach-to-hot-restart" task.
  final ProcessParentReadyTask reloadTask;

  RegenAndReload(
      {required this.stdout_,
      required this.regenTask,
      required this.reloadTask});

  bool get isGeneratingMetaStories =>
      regenTask.childTaskStatus == ChildTaskStatus.running;
  bool get isReloading => reloadTask.childTaskStatus == ChildTaskStatus.running;

  @override
  bool get isRunning => isGeneratingMetaStories || isReloading;

  @override
  void manage() {
    var needsReload = false;
    final heartbeat = Heartbeat(heartbeatMessage, stdout_.writeln);

    void reload() {
      requestReload();
      needsReload = false;
    }

    regenTask.childTaskStatusStream.listen((childTaskStatus) {
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          if (!heartbeat.isActive) {
            heartbeat.start();
          }
          break;

        case ChildTaskStatus.done:
          needsReload = true;
          if (!isReloading) {
            reload();
          }
          break;

        case ChildTaskStatus.failed:
          break;

        default:
      }
    });

    reloadTask.childTaskStatusStream.listen((childTaskStatus) {
      /// Status and messages when hot reloading:
      ///
      /// - running: "Performing hot reload"
      /// - done:    "Reloaded \d+ of \d+ libraries" or "Reloaded \d+ libraries"
      /// - failed:  "Try again after fixing the above error(s)."
      ///
      /// GOTCHA: when hot reload fails, it only emits the failed status, it
      /// does not emit the done status.

      /// Status and messages when hot restarting:
      ///
      /// - running: "Performing hot restart"
      /// - done:    "Restarted application"
      /// - failed:  "Try again after fixing the above error(s)."
      ///
      /// GOTCHA: when hot restart fails, it emits both the done status
      /// and the failed status.

      /// If we get a done or failed status, then we complete the heartbeat.
      /// The guards prevent the heartbeat from being completed again if we
      /// get another done or failed status. For example, hot restart emits
      /// the done status and then the failed status.
      ///
      /// If the status is failed, then print a message to the user to try
      /// again.
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          break;

        case ChildTaskStatus.done:
        case ChildTaskStatus.failed:
          if (needsReload) {
            reload();
          } else {
            if (!isGeneratingMetaStories && heartbeat.isActive) {
              heartbeat.complete();
            }
          }

          if (childTaskStatus == ChildTaskStatus.failed) {
            stdout_.writeln(kTryAgainAfterFixing);
          }

          break;

        default:
      }
    });
  }
}

class RegenAndHotReload extends RegenAndReload {
  @override
  String get heartbeatMessage => kReloadingStories;

  @override
  void requestReload() => requestHotReload(reloadTask);

  RegenAndHotReload(
      {required StandardOutput stdout_,
      required ProcessParentReadyTask regenTask,
      required ProcessParentReadyTask reloadTask})
      : super(stdout_: stdout_, regenTask: regenTask, reloadTask: reloadTask);
}

class RegenAndHotRestart extends RegenAndReload {
  @override
  String get heartbeatMessage => kReloadingStoriesHotRestart;

  @override
  void requestReload() => requestHotRestart(reloadTask);

  RegenAndHotRestart(
      {required StandardOutput stdout_,
      required ProcessParentReadyTask regenTask,
      required ProcessParentReadyTask reloadTask})
      : super(stdout_: stdout_, regenTask: regenTask, reloadTask: reloadTask);
}

class RegenRebundleAndHotRestart extends TasksManager with Log {
  final StandardOutput stdout_;
  final ProcessParentReadyTask regenTask;
  final ProcessTask buildPreviewBundleTask;
  final ControllerGrpcClient controllerGrpcClient;

  RegenRebundleAndHotRestart({
    required this.stdout_,
    required this.regenTask,
    required this.buildPreviewBundleTask,
    required this.controllerGrpcClient,
  });

  @override
  bool get isRunning =>
      regenTask.childTaskStatus == ChildTaskStatus.running ||
      buildPreviewBundleTask.status == TaskStatus.running;

  final reloadHeartbeat =
      TaskCountHeartbeat(kReloadingStoriesHotRestart, taskCount: 2);

  @override
  void manage() {
    regenTask.childTaskStatusStream.listen((childTaskStatus) {
      switch (childTaskStatus) {
        case ChildTaskStatus.running:
          if (!reloadHeartbeat.isActive) {
            reloadHeartbeat.completedTaskCount = 0;
            reloadHeartbeat.start();
          }
          break;

        case ChildTaskStatus.done:
          reloadHeartbeat.completedTaskCount = 1;
          rebundle();
          break;

        case ChildTaskStatus.failed:
          break;

        default:
      }
    });
  }

  void rebundle() async {
    await buildPreviewBundleTask.run();
    await buildPreviewBundleTask.done();
    if (buildPreviewBundleTask.status == TaskStatus.failed) {
      reloadHeartbeat.completeError();
    }
    else {
      restartPreview();
      reloadHeartbeat.complete();
    }
  }

  void restartPreview() async {
    if (controllerGrpcClient.isClientInitialized) {
      log.fine('Sending restartPreview request to controller grpc client');
      controllerGrpcClient.client!.restartPreview(Empty());
    } else {
      log.warning(
          'Unable to hot restart. The controller grpc client is not initialized.');
    }
  }
}
