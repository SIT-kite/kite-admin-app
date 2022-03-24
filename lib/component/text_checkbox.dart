import 'package:flutter/material.dart';

class TextCheckbox extends StatefulWidget {
  final Widget? title;
  final bool initialState;
  const TextCheckbox({
    Key? key,
    this.title,
    this.initialState = false,
  }) : super(key: key);

  @override
  State<TextCheckbox> createState() => _TextCheckboxState();
}

class _TextCheckboxState extends State<TextCheckbox> {
  late bool state;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AbsorbPointer(
            child: Checkbox(
              value: state,
              onChanged: (value) {},
            ),
          ),
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: widget.title!,
            ),
        ],
      ),
      onTap: () {
        setState(() {
          state = !state;
        });
      },
    );
  }
}
