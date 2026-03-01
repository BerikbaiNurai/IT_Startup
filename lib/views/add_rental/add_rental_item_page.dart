import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../data/mock_data.dart';
import '../../viewmodels/product_provider.dart';
import '../../viewmodels/rental_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddRentalItemPage extends StatefulWidget {
  const AddRentalItemPage({super.key});

  @override
  State<AddRentalItemPage> createState() => _AddRentalItemPageState();
}

class _AddRentalItemPageState extends State<AddRentalItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentPriceController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _depositController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = MockData.categories[1];
  String _selectedCondition = 'Good';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rentPriceController.dispose();
    _buyPriceController.dispose();
    _depositController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final rentalProvider = Provider.of<RentalProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_buyPriceController.text) ?? 0,
      rentPricePerDay: double.tryParse(_rentPriceController.text) ?? 0,
      deposit: double.tryParse(_depositController.text) ?? 0,
      category: _selectedCategory,
      ownerId: user.id,
      ownerName: user.name,
      ownerRating: user.rating,
      location: 'Алматы',
      images: _imageUrlController.text.trim().isNotEmpty
          ? [_imageUrlController.text.trim()]
          : [],
      condition: _selectedCondition,
      isRental: true,
    );

    await Future.delayed(const Duration(seconds: 1));

    productProvider.addProduct(product);
    rentalProvider.addRentalItem(product);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Товар успешно добавлен!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить товар для аренды'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'Название товара',
                hint: 'Введите название',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Описание',
                hint: 'Опишите товар',
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                ),
                items: MockData.categories
                    .where((c) => c != 'Все')
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Цена покупки (тг)',
                      hint: '0',
                      controller: _buyPriceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите цену';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Аренда/день (тг)',
                      hint: '0',
                      controller: _rentPriceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите цену';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Депозит (тг)',
                hint: '0',
                controller: _depositController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите депозит';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Состояние',
                ),
                items: ['New', 'Good', 'Used']
                    .map((condition) => DropdownMenuItem(
                          value: condition,
                          child: Text(condition == 'New'
                              ? 'Новое'
                              : condition == 'Good'
                                  ? 'Хорошее'
                                  : 'Б/у'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCondition = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'URL изображения',
                hint: 'https://images.unsplash.com/...',
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                prefixIcon: const Icon(Icons.image),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Добавить товар',
                onPressed: _isLoading ? null : _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

