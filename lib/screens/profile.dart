import 'package:feedr/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, title: 'Account', actions: [
        IconButton(
            onPressed: () {
              // Get.to(EditScreen());
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ))
      ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: usersCollection.doc(user.uid).snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            return Column(
              children: [
                SizedBox(height: Get.height * 0.08),
                Center(
                  //TODO Display user profile image
                  child: Container(
                    height: Get.height * 0.18,
                    width: Get.height * 0.18,
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: streamSnapshot.data['Image'] != 'Image goes here'
                          ? Image.network(
                              streamSnapshot.data['Image'],
                              fit: BoxFit.cover,
                            )
                          : Center(
                              //TODO Place your place holder Image                          child:Image.asset('assets/noImages.png'),
                              ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.08),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: streamSnapshot.data['Name'],
                    icon: Icons.person_outline,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: streamSnapshot.data['Email'],
                    icon: Icons.email_outlined,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                Container(
                  child: buildShowUserNameAndEmail(
                    text: 'Logout',
                    onPress: () {
                      _auth.signOut();
                      // Get.to(() => OnBoardingScreen());
                    },
                    icon: Icons.logout,
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
              ],
            );
          },
        ),
      ),
    );
  }
}
