import 'package:flutter/material.dart';
import 'package:money_manage/ultils/colors_and_size.dart';

class HomeProfileTab extends StatelessWidget {
  const HomeProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        automaticallyImplyLeading: false,
        leading: const Icon(
          Icons.arrow_back_ios,
          color: fontSubheading,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: defaultSpacing),
            child: Icon(
              Icons.settings,
              color: fontSubheading,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: defaultSpacing / 4,
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(defaultRadius)),
                        child: Image.asset(
                          "assest/picture/like.png",
                          height: 90,
                        ),
                      ),
                      const SizedBox(
                        height: defaultSpacing / 3,
                      ),
                      Text(
                        "name",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700, color: fontHeading),
                      ),
                      Text(
                        'email',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: fontSubheading),
                      ),
                      const SizedBox(
                        height: defaultSpacing / 2,
                      ),
                      const Chip(
                        backgroundColor: primaryLight,
                        label: Text('Sửa thông tin cá nhân'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: defaultSpacing / 2,
                    ),
                    Text(
                      'Tổng quan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700, color: fontHeading),
                    ),
                    const SizedBox(
                      height: defaultSpacing / 4,
                    ),
                    const ProfileAccountInfoTitle(
                        title: "Giới tính",//userdata.gender
                        subTitle: "f" ,
                        imageUrl: 'f' == "Nữ"
                            ? "assest/icon/female-icon.png"
                            : "assest/icon/male-icon.png"),
                    const ProfileAccountInfoTitle(
                        title: 'Ngày sinh',
                        subTitle: 'subTitle',
                        imageUrl: "assest/icon/male-icon.png")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileAccountInfoTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imageUrl;
  const ProfileAccountInfoTitle(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: defaultSpacing),
          child: Image.asset(imageUrl),
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: fontHeading, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: fontSubheading),
        ),
        // trailing: const Icon(
        //   Icons.keyboard_arrow_right_rounded,
        //   color: fontSubheading,
        // ),
      ),
    );
  }
}
