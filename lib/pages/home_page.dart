import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/Icon_Info.png",
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "DASHBOARD",
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        leading: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("assets/logo.png"),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: const Column(
                  children: [
                    Text(
                      'HI NGUYÊN BUỔI SÁNG',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Một ngày làm việc vui vẻ nha !',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
            height: 210,
            color: const Color(0XFF465475),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.expand_less,
                        size: 32,
                        color: Color.fromARGB(199, 172, 176, 184),
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chức năng chính',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        'Xem thêm',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffF9CA54),
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Tạo button
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: const Color(0xff525F80),
                            textColor: Colors.white,
                            child: Image.asset(
                              "assets/Icon_Notify.png",
                            ),
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Thông báo',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: const Color(0xff525F80),
                            textColor: Colors.white,
                            child: Image.asset(
                              "assets/Icon_AICam.png",
                            ),
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Check-in AI',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: const Color(0xff525F80),
                            textColor: Colors.white,
                            child: Image.asset(
                              "assets/Icon_Maps.png",
                            ),
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Check-in GPS',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            color: const Color(0xffF9CA54),
                            textColor: Colors.white,
                            child: Image.asset(
                              "assets/Icon_Documents.png",
                            ),
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Đăng ký nghĩ phép',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
