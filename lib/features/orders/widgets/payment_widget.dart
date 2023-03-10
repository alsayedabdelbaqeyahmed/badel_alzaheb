import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardPymentWidget extends StatefulWidget {
  const CardPymentWidget({Key? key}) : super(key: key);

  @override
  State<CardPymentWidget> createState() => _CardPymentWidgetState();
}

class _CardPymentWidgetState extends State<CardPymentWidget> {
  TextEditingController cardNumberController = TextEditingController();

  CardType cardType = CardType.Invalid;

  @override
  Widget build(BuildContext context) {
    return Center(
      // backgroundColor: Colors.white,
      // appBar: AppBar(title: const Text("New card")),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Spacer(),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(19),
                    ],
                    decoration: InputDecoration(hintText: "Card number"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Full name"),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            // Limit the input
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(hintText: "CVV"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration: const InputDecoration(hintText: "MM/YY"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Spacer(flex: 2),
            // Padding(
            //   padding: const EdgeInsets.only(top: 16),
            //   child: ElevatedButton(
            //     child: const Text("Add card"),
            //     onPressed: () {},
            //   ),
            // ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}

enum CardType {
  Master,
  Visa,
  Verve,
  Discover,
  AmericanExpress,
  DinersClub,
  Jcb,
  Others,
  Invalid
}
