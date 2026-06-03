import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';
import 'package:genshin_import/ui/features/admin/widgets/add_image.dart';
import 'package:genshin_import/ui/features/product/widgets/confirmation_dialog.dart';
import 'package:go_router/go_router.dart';

/* =================================================================================================== */
/* =================================================================================================== */

class ProductFormView extends StatefulWidget {
  final bool isEditMode;

  const ProductFormView({
    super.key,
    this.isEditMode = true,
  });

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _ProductFormViewState extends State<ProductFormView> {
  late final TextEditingController _itemNameController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _stockController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _itemNameController.addListener(_onTextChanged);
    _stockController.addListener(_onTextChanged);
    _priceController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _itemNameController.removeListener(_onTextChanged);
    _stockController.removeListener(_onTextChanged);
    _priceController.removeListener(_onTextChanged);
    _descriptionController.removeListener(_onTextChanged);
    _itemNameController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final itemNameText = _itemNameController.text.trim();
    final stockText = _stockController.text.trim();
    final priceText = _priceController.text.trim();
    final descriptionText = _descriptionController.text.trim();

    setState(() {
      _isButtonEnabled = itemNameText.isNotEmpty && stockText.isNotEmpty && 
        priceText.isNotEmpty && descriptionText.isNotEmpty;
    });
  }

  /* ================================================================================================= */

  void _showConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,

      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          title: 'Delete item?',
          subtitle: 'Are you sure you want to delete this item?\nThis action cannot be undone.',
          deletionPage: true,
          onCancel: () async {context.pop();},
          onAccept: () async {context.pop();},
        );
      },
    );
  }

  /* ================================================================================================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 

      appBar: CustomAppbar(
        icon: Icons.arrow_back
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 32,
          children: [
            AddImagePlaceholder(
              onTap: () {},
            ),
            
            Column(
              spacing: 8,
              children: [
                SingleTextField(
                  labelText: 'Item Name',
                  hintText: 'Enter item name',
                  controller: _itemNameController,
                ),
                SingleTextField(
                  labelText: 'Stock',
                  hintText: 'Enter stock',
                  controller: _stockController,
                ),
                SingleTextField(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  controller: _priceController,
                ),
                SingleTextField(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  controller: _descriptionController,
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                spacing: 16,
                children: [
                  CustomButton(
                    label: widget.isEditMode ? 'SAVE CHANGES' : 'CREATE',
                    onPressed: _isButtonEnabled ? () async {} : null,
                  ),
              
                  if (widget.isEditMode)
              
                  TextButton(
                    onPressed: () => _showConfirmation(context),
                    child: Text(
                      'DELETE',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =================================================================================================== */
/* =================================================================================================== */
