import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndividualLiquor extends StatefulWidget {
  final String liquorName, rate, pp, brandName, category, origin;
  final Widget img;
  final VoidCallback onPressed;
  const IndividualLiquor(
      {super.key,
      required this.liquorName,
      required this.rate,
      required this.pp,
      required this.brandName,
      required this.category,
      required this.origin,
      required this.img, required this.onPressed});

  @override
  State<IndividualLiquor> createState() => _IndividualLiquorState();
}

class _IndividualLiquorState extends State<IndividualLiquor> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:widget.onPressed,
      child: Card(
        color: const Color(0xff1C1C2E),
        elevation: 2,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(width: 120, height: 140, child: widget.img),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Colors.green,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Text(
                                  'Available',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'lovelo',
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Text(
                              widget.liquorName,
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'lovelo'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.wineBottle,
                                    color: Colors.white),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.category,
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: 'poppins'),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.brandName,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'poppins',
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'From',
                                  style:
                                      TextStyle(fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.origin,
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: 'poppins'),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Rating',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.rate,
                            style: const TextStyle(
                                fontSize: 12, fontFamily: 'poppins'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Rs.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.pp,
                            style: const TextStyle(
                                fontSize: 14, fontFamily: 'poppins'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
