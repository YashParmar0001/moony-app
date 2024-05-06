import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moony_app/controller/settings_controller.dart';
import 'package:moony_app/generated/assets.dart';
import 'package:moony_app/theme/colors.dart';
import 'package:moony_app/ui/settings/screens/edit_categories_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController settingsController;

  @override
  void initState() {
    settingsController = Get.find<SettingsController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const currencyOptions = ['none', '\$', 'rs'];

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                Assets.assetsMoonyLogoNoBg,
                width: 70,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                'Moony',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Currency Unit',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: settingsController.currencyUnit,
                      items: List.generate(
                        currencyOptions.length,
                        (index) => DropdownMenuItem(
                          value: currencyOptions[index],
                          child: Text(
                            currencyOptions[index],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          settingsController.setCurrencyUnit(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'Categories',
                icon: Icons.category,
                onTap: () => Get.to(() => const EditCategoriesScreen()),
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'Invite friends',
                icon: Icons.people_alt_outlined,
                onTap: () {},
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'Give us Feedback',
                icon: Icons.feedback_outlined,
                onTap: () {},
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'Rate us',
                icon: Icons.star,
                onTap: () {},
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'About',
                icon: Icons.info_outline,
                onTap: () {},
              ),
              _buildDivider(),
              _buildOption(
                context: context,
                title: 'For developer',
                icon: Icons.developer_mode_outlined,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Icon(
              icon,
              size: 30,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1.5,
    );
  }
}
