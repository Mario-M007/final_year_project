import 'package:flutter/material.dart';

class AddonCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String name;
  final double price;

  const AddonCheckBox({
    super.key,
    required this.value,
    this.onChanged,
    required this.name,
    required this.price,
  });

  @override
  State<AddonCheckBox> createState() => _AddonCheckBoxState();
}

class _AddonCheckBoxState extends State<AddonCheckBox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          if (widget.onChanged != null) {
            widget.onChanged!(_value);
          }
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15.0),
            child: Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                color: _value ? Colors.black : Colors.transparent,
              ),
              child: _value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.0,
                    )
                  : null,
            ),
          ),
          Expanded(child: Text(widget.name)),
          Text(widget.price == 0 ? "" : "+\$${widget.price}")
        ],
      ),
    );
  }
}
