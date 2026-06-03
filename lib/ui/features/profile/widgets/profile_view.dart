import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/section_header.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/features/profile/widgets/change_username_view.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ProfileViewState extends State<ProfileView> {
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const LogoutDialog(),
    );
  }

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.myColors.neutralLightest,

      child: Column(
        children: [
          SectionHeader(
            title: 'PROFILE',
            subtitle: 'Manage your account',
          ),
      
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 32,
            
              children: [
                Column(
                  spacing: 8,
      
                  children: [
                    ProfileAvatar(),
            
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: context.myColors.neutralDarkest,
                      ),
                    )
                  ],
                ),
            
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.myColors.neutralMidLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
      
                  child: Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SettingItem(
                            icon: Icons.account_circle,
                            label: 'Change Username',
                            onTap: () => context.push('/change_username'),
                          ),
                                
                          SettingItem(
                            icon: Icons.email,
                            label: 'Change Email',
                            onTap: () => context.push('/change_email'),
                          ),
                                
                          SettingItem(
                            icon: Icons.lock,
                            label: 'Change Password',
                            onTap: () => context.push('/change_password'),
                          ),
                                
                          SettingItem(
                            icon: Icons.logout,
                            label: 'Logout',
                            showBottomDivider: false,
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ]
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myColors.neutralMidLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      
      actionsOverflowDirection: VerticalDirection.down,
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      actionsAlignment: MainAxisAlignment.center,

      title: Text(
        'Logout',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
      ),

      content: Text(
        'Are you sure you want to log out of your account?',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
      ),
      
      actions: [
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            label: 'Logout',
            onPressed: () async {
              context.pop();
            },
            variant: ButtonVariant.error,
          ),
        ),

        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.myColors.neutralDarkest,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.myColors.neutralDark!,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: context.myColors.neutralLight,
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showBottomDivider;

  const SettingItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              spacing: 16,
                    
              children: [
                Icon(
                  icon,
                  color: context.myColors.neutralDarkest,
                ),
                    
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: context.myColors.neutralDarkest,
                    ),
                  ),
                ),
                    
                Icon(
                  Icons.chevron_right,
                  color: context.myColors.neutralDarkest,
                ),
              ],
            ),
          ),
        ),

        if (showBottomDivider)
          Divider(
            color: context.myColors.neutralDark,
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
