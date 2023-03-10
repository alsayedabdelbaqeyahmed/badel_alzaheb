import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/orders/controller/count_provider.dart';

class CartCounterWidget extends ConsumerWidget {
//   @override
//   _CartCounterWidgetState createState() => _CartCounterWidgetState();
// }

// class _CartCounterWidgetState extends ConsumerState<CartCounterWidget> {
  num _numOfItems = 1;

  @override
  Widget build(BuildContext context, ref) {
    final countPro = ref.watch(countProvider);
    _numOfItems = countPro.counter;
    return Row(
      children: [
        buildOutlineButton(
          icon: Icons.add,
          onPressed: () {
            countPro.incrmentCounter();
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            _numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
          icon: Icons.remove,
          onPressed: () {
            if (_numOfItems > 1) {
              countPro.decrmentCounter();
            }
          },
        ),
      ],
    );
  }

  SizedBox buildOutlineButton(
      {required IconData icon, required Function() onPressed}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}
