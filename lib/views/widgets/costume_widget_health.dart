import 'package:flutter/material.dart';
import 'package:petpulse/model/dataexemple.dart';
import 'package:petpulse/util/paint.dart';

Text headerTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
  );
}

Container customDivider(Color color) {
  return Container(
    height: 2,
    width: double.infinity,
    color: color,
  );
}

Future<void> newMeasureaddModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 360,
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: measurelist.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(10),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: measurelist[index].color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      measurelist[index].color.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  measurelist[index].icon,
                                  size: 20,
                                  color: measurelist[index].color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                measurelist[index].name,
                                style: const TextStyle(
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

GridView healthGridviewCard(DateTime selectedDate) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: measure.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
    ),
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: measure[index].measuredata.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        measure[index].measuredata.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: measure[index].measuredata.color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      measure[index].measuredata.icon,
                      color: measure[index].measuredata.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              (measure[index].isradial == "true")
                  ? SizedBox(
                      height: 120,
                      width: 120,
                      child: CustomPaint(
                        foregroundPainter: RadialPainter(
                          bgcolor:
                              measure[index].measuredata.color.withOpacity(0.2),
                          lineColor: measure[index].measuredata.color,
                          percent: measure[index].values * 10 / 100,
                          width: 4.0,
                        ),
                        child: Center(
                          child: Text(
                            '${measure[index].values}${measure[index].unit}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 120,
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int i = 2; i <= 4; i += 2)
                            Container(
                              height: i * 10.toDouble(),
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: measure[index]
                                    .measuredata
                                    .color
                                    .withOpacity(0.4),
                              ),
                            ),
                          for (int i = 5; i > 1; i -= 3)
                            Container(
                              height: i * 10.toDouble(),
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: measure[index]
                                    .measuredata
                                    .color
                                    .withOpacity(0.5),
                              ),
                            ),
                          for (int i = 4; i >= 1; i -= 2)
                            Container(
                              height: i * 10.toDouble(),
                              width: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: measure[index]
                                    .measuredata
                                    .color
                                    .withOpacity(0.4),
                              ),
                            ),
                        ],
                      ),
                    ),
              (measure[index].isradial != "true")
                  ? Text(
                      '${measure[index].values} ${measure[index].unit}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    },
  );
}
