import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/widgets/story_list/search_field.dart';
import 'package:monarch_controller/widgets/story_list/text_with_highlight.dart';
import 'package:monarch_controller/widgets/tree_view/flutter_simple_treeview.dart';
import 'package:monarch_controller/manager/controller_manager.dart';

import '../../../utils/translations.dart';
import '../components/no_stories_found_text.dart';

class StoryList extends StatefulWidget {
  const StoryList({
    Key? key,
    required this.stories,
    required this.projectName,
    required this.manager,
    this.activeStoryKey,
    this.onActiveStoryChange,
  }) : super(key: key);

  final List<StoryGroup> stories;
  final String projectName;
  final String? activeStoryKey;
  final Function(String key)? onActiveStoryChange;
  final ControllerManager manager;

  @override
  State<StatefulWidget> createState() => StoryListState();
}

class StoryListState extends State<StoryList> {
  final controller = TextEditingController();
  String query = '';
  bool _focused = false;
  final _storyListFocusNode = FocusNode();
  final _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _filteredStories =
        widget.manager.filterStories(widget.stories, query);
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SearchField(
            controller: controller,
            focusNode: _searchFocusNode,
            canReset: query.isNotEmpty,
            hint: Translations.of(context)?.text('story_list.search'),
            onReset: () {
              query = '';
              controller.text = query;
              setState(() {});
            },
            onChanged: _onQueryChanged,
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    // BorderSide(width: 1, color: Theme.of(context).dividerColor),
                    BorderSide(
                        width: 1, color: _focused ? Colors.red : Colors.blue)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Focus(
                focusNode: _storyListFocusNode,
                onFocusChange: (focused) => setState(() => _focused = focused),
                onKey: (node, event) {
                  if (event is! RawKeyDownEvent) {
                    return KeyEventResult.ignored;
                  }
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    widget.manager.onUpperStoryRequested();
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    widget.manager.onLowerStoryRequested();
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: SingleChildScrollView(
                    child: Container(
                  child: _filteredStories.isEmpty
                      ? const NoStoriesFoundWidget()
                      : TreeView(
                          nodes: _filteredStories
                              .map((group) => TreeNode(
                                    onNodeClicked: () {
                                      _storyListFocusNode.requestFocus();
                                      widget.manager
                                          .onGroupToggle(group.groupKey);
                                    },
                                    content: TextWithHighlight(
                                      text: group.groupName,
                                      highlightedText: query,
                                    ),
                                    children: group.stories
                                        .map(
                                          (story) => TreeNode(
                                            content: InkWell(
                                              onTap: () {
                                                _storyListFocusNode
                                                    .requestFocus();
                                                widget.onActiveStoryChange
                                                    ?.call(story.key);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                  left: 40,
                                                  top: 4,
                                                  bottom: 4,
                                                  right: 8,
                                                ),
                                                color: widget.activeStoryKey ==
                                                        story.key
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                child: TextWithHighlight(
                                                  text: story.name,
                                                  highlightedText: query,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ))
                              .toList()),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _searchFocusNode.dispose();
    _storyListFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    query = value;

    setState(() {});
  }
}
