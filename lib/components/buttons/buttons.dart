import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerStatefulWidget {
  const CustomButton(
      {super.key,
      required this.text,
      this.icon,
      this.iconSpaced = MainAxisAlignment.center,
      this.borderRadius = 10,
      this.onClick,
      this.leftAlign = true});

  final String text;
  final Icon? icon;
  final bool leftAlign;
  final MainAxisAlignment? iconSpaced;
  final double borderRadius;
  final Function? onClick;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CustomButtonState();
}

class CustomButtonState extends ConsumerState<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF0D29FF),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(120, 54),
          ),
          shadowColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFFF3F3F5),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
          ),
          elevation: MaterialStateProperty.all(5),
          // splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () {
          widget.onClick!();
        },
        child: Row(
          mainAxisAlignment: widget.iconSpaced ?? MainAxisAlignment.center,
          children: [
            if (widget.icon != null && widget.leftAlign == true) ...[
              widget.icon!,
              const SizedBox(
                width: 10,
              )
            ],
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            if (widget.icon != null && widget.leftAlign == false) ...[
              const SizedBox(
                width: 20,
              ),
              widget.icon!
            ]
          ],
        ));
  }
}

class CustomIconButton extends ConsumerStatefulWidget {
  const CustomIconButton(
      {super.key, required this.text, required this.icon, this.onClick});
  final String text;
  final Icon icon;
  final Function? onClick;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomIconButtonState();
}

class _CustomIconButtonState extends ConsumerState<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          widget.onClick!();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFF0D29FF),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(120, 54),
          ),
          shadowColor: MaterialStateColor.resolveWith(
            (states) => const Color(0xFFF3F3F5),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
          ),
          elevation: MaterialStateProperty.all(5),
          // splashFactory: NoSplash.splashFactory,
        ),
        icon: widget.icon,
        label: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ));
  }
}

class CustomSecondaryButton extends ConsumerStatefulWidget {
  const CustomSecondaryButton({super.key, required this.text, this.onClick});

  final String text;
  final Function? onClick;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomSecondaryButtonState();
}

class _CustomSecondaryButtonState extends ConsumerState<CustomSecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xFFE6E9EE),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            elevation: MaterialStateProperty.all(5),

            // splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            widget.onClick!();
          },
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Color(0xFF777C8D),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
    ;
  }
}

class CustomOutlineButton extends ConsumerStatefulWidget {
  const CustomOutlineButton({super.key, required this.text, this.onClick});
  final String text;
  final Function? onClick;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends ConsumerState<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(120, 54),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          side: const BorderSide(
            color: Color(0xFF0D29FF),
            width: 1.5,
          ),
        ),
        child: Text(widget.text,
            style: const TextStyle(
              color: Color(0xFF0D29FF),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )));
  }
}
