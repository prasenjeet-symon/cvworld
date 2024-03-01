import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/account-page/account-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/account-page/account-page.web.dart';
import 'package:cvworld/client/shared/confirmation-dialog/confirmation-dialog.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'account-page.controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const AccountPageMobile();
      } else {
        // Desktop
        return const AccountPageWeb();
      }
    });
  }
}

///
///
///
/// Account page profile
class AccountPageProfile extends StatefulWidget {
  const AccountPageProfile({super.key});

  @override
  State<AccountPageProfile> createState() => _AccountPageProfileState();
}

class _AccountPageProfileState extends State<AccountPageProfile> {
  AccountPageController controller = AccountPageController();

  User? user;
  bool isLoading = true;
  Uint8List? attachment;
  String? attachmentName;
  StreamSubscription? _subscription;
  StreamSubscription? _subscription2;
  StreamSubscription? _subscription3;
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getUser().listen((event) {
      if (mounted) {
        setState(() {
          user = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });

    _subscription2 = controller.isSubscribed().listen((event) {
      if (mounted) {
        setState(() {
          isSubscribed = event;
        });
      }
    });

    _subscription3 = ApplicationToken.getInstance().observable.listen((event) {
      if (event == null) {
        context.goNamed(RouteNames.signin);
      }
    });
  }

  // Pick attachment
  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          attachment = result.files.first.bytes;
          attachmentName = result.files.first.name;
        });

        uploadProfilePicture();
      }
    }
  }

  // Upload profile picture
  Future<void> uploadProfilePicture() async {
    if (attachment == null || attachmentName == null || user == null) {
      return;
    }

    try {
      user?.profilePictureFile = attachment;
      user?.profilePictureFileName = attachmentName;
      controller.updateUser(user!);
    } catch (e) {
      if (kDebugMode) {
        print('uploadProfilePicture :: cannot upload profile picture for user');
        print(e);
      }
    }
  }

  _signOut() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Are you sure?",
        message: "Are you sure you want to sign out?",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        onConfirm: () {
          ApplicationToken.getInstance().deleteToken();
        },
        onCancel: () {},
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription2?.cancel();
    _subscription3?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // is Mobile
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    if (isLoading) {
      return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 2 : 1,
            child: GestureDetector(
              onTap: () {
                pickAttachment();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(NetworkApi.publicResource(user?.profilePicture ?? 'https://picsum.photos/200')),
                  minRadius: isMobile ? 50 : 70,
                  maxRadius: isMobile ? 50 : 70,
                  child: user?.fileUploadProgress == 0.00 || user?.fileUploadProgress == 100.00 ? const Icon(Icons.edit) : const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(user?.fullName ?? '', style: TextStyle(fontSize: isMobile ? 25 : 30, fontWeight: FontWeight.bold)),
                      !isMobile
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: isSubscribed ? const Chip(label: Text('Premium'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white)) : null,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(user?.email ?? '', style: TextStyle(fontSize: isMobile ? 15 : 17, fontWeight: FontWeight.normal)),
                  isMobile
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: isSubscribed ? const Chip(label: Text('Premium'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white)) : null,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          !isMobile
              ? Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 40,
                    width: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

///
///
///
/// Account Page Details
class AccountPageDetails extends StatefulWidget {
  const AccountPageDetails({super.key});

  @override
  State<AccountPageDetails> createState() => _AccountPageDetailsState();
}

class _AccountPageDetailsState extends State<AccountPageDetails> {
  AccountPageController controller = AccountPageController();

  User? user;
  bool isLoading = true;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getUser().listen((event) {
      if (mounted) {
        setState(() {
          user = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: const Text('Account Details', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 6, child: Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        Text(user?.fullName ?? '', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 6, child: Text('Username', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        Text(user?.userName ?? '', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 6, child: Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        Text(user?.email ?? '', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),
                  Container(
                    // border bottom
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(flex: 6, child: Text('Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        Text('********', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

///
///
///
/// Account payment details
class AccountPagePayment extends StatefulWidget {
  const AccountPagePayment({super.key});

  @override
  State<AccountPagePayment> createState() => _AccountPagePaymentState();
}

class _AccountPagePaymentState extends State<AccountPagePayment> {
  AccountPageController controller = AccountPageController();

  bool isSubscribed = false;
  Subscription? subscription;
  UserSubscription? userSubscription;
  bool isLoading = true;
  StreamSubscription? _subscription;
  StreamSubscription? _subscription2;
  StreamSubscription? _subscription3;

  @override
  void initState() {
    super.initState();

    _subscription = controller.isSubscribed().listen((event) {
      if (mounted) {
        setState(() {
          isSubscribed = event;
        });
      }
    });

    _subscription2 = controller.getSubscriptionPlan().listen((event) {
      if (mounted) {
        setState(() {
          subscription = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });

    _subscription3 = controller.getSubscription().listen((event) {
      if (mounted) {
        setState(() {
          userSubscription = event.data.isNotEmpty ? event.data[0] : null;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription2?.cancel();
    super.dispose();
  }

  // Subscribe
  _subscribe() {
    controller.subscribeNow();
    openLinkInBrowser(userSubscription?.subscriptionLink ?? '');
  }

  // Cancel subscription
  _cancelSubscription() {
    // dialog
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Are you sure?",
          message: "Are you sure you want to cancel subscription?",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          onConfirm: () {
            controller.cancelSubscription();
          },
          onCancel: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    if (isLoading) {
      return const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator()));
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: const Text('Membership Details', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment description with pricing
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        subscription?.description ?? 'Get access to all premium templates with monthly subscription',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  if (!isMobile)
                    isSubscribed
                        ? TextButton(
                            onPressed: () {
                              _cancelSubscription();
                            },
                            child: const Text('Cancel'))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () {
                              _subscribe();
                            },
                            child: const Text('Upgrade', style: TextStyle(fontSize: 15, color: Colors.white)),
                          )
                ],
              ),
            ),
            if (isMobile)
              isSubscribed
                  ? TextButton(
                      onPressed: () {
                        _cancelSubscription();
                      },
                      child: const Text('Cancel'))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        _subscribe();
                      },
                      child: const Text('Upgrade', style: TextStyle(fontSize: 15, color: Colors.white)),
                    )
          ],
        ),
      ),
    );
  }
}

///
///
///
/// Delete account
class AccountPageDelete extends StatefulWidget {
  const AccountPageDelete({super.key});

  @override
  State<AccountPageDelete> createState() => _AccountPageDeleteState();
}

class _AccountPageDeleteState extends State<AccountPageDelete> {
  AccountPageController controller = AccountPageController();

  @override
  void initState() {
    super.initState();
  }

  // Delete user
  void _deleteUser() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Are you sure?",
          message: "Are you sure you want to delete your account?",
          confirmButtonText: "Yes",
          cancelButtonText: "No",
          onConfirm: () {
            controller.deleteUser();
          },
          onCancel: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Card(
      child: Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: const Text('Delete Account', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment description with pricing
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        'Are you sure you want to delete your account? This action cannot be undone',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  !isMobile
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () {
                            _deleteUser();
                          },
                          child: const Text('Delete', style: TextStyle(fontSize: 15, color: Colors.white)),
                        )
                      : Container()
                ],
              ),
            ),
            isMobile
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      _deleteUser();
                    },
                    child: const Text('Delete', style: TextStyle(fontSize: 15, color: Colors.white)),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
