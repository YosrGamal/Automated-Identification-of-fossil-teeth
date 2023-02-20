import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'detail_page.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final List<Map<String, dynamic>> images = [
    {
      'id': 'i1',
      'title': 'Shark',
      'url':
          'https://www.fossils-uk.com/images/3-5-inch-miocene-megalodon-fossil-shark-tooth-from-south-carolina-usa-sku-v2865-otodus-carcharocles-megalodon-p5349-15096_zoom.jpg'
    },
    {
      'id': 'i2',
      'title': 'Shark',
      'url':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiLHojdSIUwnmrneOVpTxs3AgTf0-4YgS8ELxfWw5NWEi5yny-MRGeX8tsv_9PKKiU0ok&usqp=CAU'
    },
    {
      'id': 'i3',
      'title': 'Crocodile',
      'url':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN98ngDvflsdyXn2hI1wHR9w5rPSqLyggqdQ&usqp=CAU'
    },
    {
      'id': 'i4',
      'title': 'Crocodile',
      'url':
          'https://i.pinimg.com/originals/d3/7c/f0/d37cf044ed9aa78dba995aeba9d5030e.jpg'
    },
    {
      'id': 'i5',
      'title': 'Elephant',
      'url':
          'https://paleoenterprises.com/wp-content/uploads/2021/8855/2021-09-04-23.33.32.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.center,
          height: 54,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  width: 2, color: const Color.fromARGB(255, 199, 198, 198))),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontFamily: "Inter",
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 120.0),
        child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15),
            itemCount: images.length,
            itemBuilder: (BuildContext ctx, index) {
              return Card(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 16 / 16,
                          child: InkWell(
                            key: ValueKey(images[index]['id']),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                        image: images[index],
                                      )));
                            },
                            child: Hero(
                              tag: images[index]['id'],
                              child: Image.network(
                                images[index]['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          images[index]['title'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Center(
              child: Text(
                'Library',
                style: TextStyle(
                    color: kTextColor, fontFamily: 'Inter', fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    ]));
  }
}