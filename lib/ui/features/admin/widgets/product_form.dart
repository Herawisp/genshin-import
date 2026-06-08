import 'package:flutter/material.dart';
import 'package:genshin_import/data/models/weapon.dart';
import 'package:genshin_import/data/services/weapon_api_service.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';
import 'package:genshin_import/ui/core/widgets/appbar/appbar.dart';
import 'package:genshin_import/ui/core/widgets/button.dart';
import 'package:genshin_import/ui/core/widgets/text_fields/single_text_field.dart';
import 'package:genshin_import/ui/features/admin/widgets/add_image.dart';
import 'package:genshin_import/ui/features/product/widgets/confirmation_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProductFormView extends StatefulWidget {
  final Weapon? weapon;

  const ProductFormView({super.key, this.weapon});

  bool get isEditMode => weapon != null;

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final WeaponApiService _weaponApiService = WeaponApiService();
  final ImagePicker _imagePicker = ImagePicker();
  late final TextEditingController _itemNameController;
  late final TextEditingController _typeController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _detailController;
  bool _isButtonEnabled = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final weapon = widget.weapon;

    _itemNameController = TextEditingController(text: weapon?.name ?? '');
    _typeController = TextEditingController(text: weapon?.type ?? '');
    _stockController = TextEditingController(
      text: weapon == null ? '' : weapon.stock.toString(),
    );
    _priceController = TextEditingController(
      text: weapon == null ? '' : weapon.formattedPrice,
    );
    _imageController = TextEditingController(text: weapon?.image ?? '');
    _descriptionController = TextEditingController(
      text: weapon?.description ?? '',
    );
    _detailController = TextEditingController(text: weapon?.detail ?? '');

    _itemNameController.addListener(_onTextChanged);
    _typeController.addListener(_onTextChanged);
    _stockController.addListener(_onTextChanged);
    _priceController.addListener(_onTextChanged);
    _imageController.addListener(_onTextChanged);
    _descriptionController.addListener(_onTextChanged);
    _detailController.addListener(_onTextChanged);
    _onTextChanged();
  }

  @override
  void dispose() {
    _itemNameController.removeListener(_onTextChanged);
    _typeController.removeListener(_onTextChanged);
    _stockController.removeListener(_onTextChanged);
    _priceController.removeListener(_onTextChanged);
    _imageController.removeListener(_onTextChanged);
    _descriptionController.removeListener(_onTextChanged);
    _detailController.removeListener(_onTextChanged);
    _itemNameController.dispose();
    _typeController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final itemNameText = _itemNameController.text.trim();
    final typeText = _typeController.text.trim();
    final stockText = _stockController.text.trim();
    final priceText = _priceController.text.trim();
    final imageText = _imageController.text.trim();
    final descriptionText = _descriptionController.text.trim();
    final detailText = _detailController.text.trim();

    setState(() {
      _isButtonEnabled =
          itemNameText.isNotEmpty &&
          typeText.isNotEmpty &&
          stockText.isNotEmpty &&
          priceText.isNotEmpty &&
          imageText.isNotEmpty &&
          descriptionText.isNotEmpty &&
          detailText.isNotEmpty &&
          !_isSaving;
    });
  }

  String? _validateInput() {
    if (!_isButtonEnabled && !_isSaving) {
      return 'All fields are required';
    }

    final stock = int.tryParse(_stockController.text.trim());

    if (stock == null) {
      return 'Stock must be a number';
    }

    if (stock < 0) {
      return 'Stock cannot be negative';
    }

    final price = double.tryParse(_priceController.text.trim());

    if (price == null) {
      return 'Price must be a number';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    return null;
  }

  Weapon _buildWeapon() {
    return Weapon(
      id: widget.weapon?.id ?? 0,
      name: _itemNameController.text.trim(),
      type: _typeController.text.trim(),
      description: _descriptionController.text.trim(),
      detail: _detailController.text.trim(),
      stock: int.parse(_stockController.text.trim()),
      image: _imageController.text.trim(),
      price: double.parse(_priceController.text.trim()),
    );
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      _imageController.text = image.path;
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to open image picker');
      }
    }
  }

  Future<void> _saveWeapon() async {
    final validationError = _validateInput();

    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    setState(() {
      _isSaving = true;
      _isButtonEnabled = false;
      _errorMessage = null;
    });

    try {
      final weapon = _buildWeapon();

      if (widget.isEditMode) {
        await _weaponApiService.updateWeapon(weapon);
      } else {
        await _weaponApiService.createWeapon(weapon);
      }

      if (mounted) {
        context.pop(true);
      }
    } on WeaponApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to save weapon');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        _onTextChanged();
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    final weapon = widget.weapon;

    if (weapon == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: context.myColors.darken,
      builder: (dialogContext) {
        return ConfirmationDialog(
          title: 'Delete item?',
          subtitle:
              'Are you sure you want to delete this item?\nThis action cannot be undone.',
          deletionPage: true,
          onCancel: () async => dialogContext.pop(),
          onAccept: () async {
            await _deleteWeapon(dialogContext, weapon.id);
          },
        );
      },
    );
  }

  Future<void> _deleteWeapon(BuildContext dialogContext, int id) async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _weaponApiService.deleteWeapon(id);

      if (dialogContext.mounted) {
        dialogContext.pop();
      }

      if (mounted) {
        context.pop(true);
      }
    } on WeaponApiException catch (error) {
      if (mounted) {
        setState(() => _errorMessage = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unable to delete weapon');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
        _onTextChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppbar(
          icon: Icons.arrow_back,
          titleText: widget.isEditMode ? 'Edit Weapon' : 'Create Weapon',
          showTitleText: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              spacing: 24,
              children: [
                AddImagePlaceholder(
                  imagePath: _imageController.text,
                  onTap: _pickImage,
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
                      labelText: 'Type',
                      hintText: 'Enter weapon type',
                      controller: _typeController,
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
                    SingleTextField(
                      labelText: 'Detail',
                      hintText: 'Enter detail description',
                      controller: _detailController,
                      minLines: 4,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ],
                ),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.myColors.error,
                    ),
                  ),
                CustomButton(
                  label: widget.isEditMode ? 'SAVE CHANGES' : 'CREATE',
                  onPressed: _isButtonEnabled ? _saveWeapon : null,
                  oneShot: true,
                ),
                if (widget.isEditMode)
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => _showDeleteConfirmation(context),
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
        ),
      ),
    );
  }
}
