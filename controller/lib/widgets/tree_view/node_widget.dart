///Code credits to https://pub.dev/packages/flutter_simple_treeview

import 'package:flutter/material.dart';

import 'builder.dart';
import 'primitives/tree_controller.dart';
import 'primitives/tree_node.dart';

/// Widget that displays one [TreeNode] and its children.
class NodeWidget extends StatefulWidget {
  final TreeNode treeNode;
  final double? indent;
  final double? iconSize;
  final TreeController state;
  final VoidCallback? onNodeClicked;

  const NodeWidget(
      {Key? key,
      required this.treeNode,
      this.indent,
      required this.state,
      this.onNodeClicked,
      this.iconSize})
      : super(key: key);

  @override
  _NodeWidgetState createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool get _isLeaf {
    return widget.treeNode.children == null ||
        widget.treeNode.children!.isEmpty;
  }

  bool get _isExpanded {
    return widget.state.isNodeExpanded(widget.treeNode.key!);
  }

  @override
  Widget build(BuildContext context) {
    var icon = _isLeaf
        ? null
        : _isExpanded
            ? Icons.expand_more
            : Icons.chevron_right;

    var onNodeClicked = _isLeaf
        ? null
        : () {
            widget.onNodeClicked?.call();
            setState(
                () => widget.state.toggleNodeExpanded(widget.treeNode.key!));
          };

    return InkWell(
      onTap: onNodeClicked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onNodeClicked != null) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  child: Icon(
                    icon,
                    size: 16,
                  ),
                ),
              ],
              Expanded(child: widget.treeNode.content),
            ],
          ),
          if (_isExpanded && !_isLeaf)
            Padding(
              padding: EdgeInsets.zero,
              child: buildNodes(widget.treeNode.children!, widget.indent,
                  widget.state, widget.iconSize),
            )
        ],
      ),
    );
  }
}
