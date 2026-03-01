import '../models/item.dart';

class ItemsService {
  static final List<Item> _items = [
    Item(
      id: '1',
      title: 'Камера Canon EOS R5',
      description: 'Профессиональная камера для фото и видео съемки. В комплекте объектив 24-70mm.',
      category: 'Электроника',
      pricePerDay: 2500,
      deposit: 50000,
      ownerId: 'owner1',
      ownerName: 'Иван Петров',
      ownerRating: 4.8,
      location: 'Москва',
      images: [],
    ),
    Item(
      id: '2',
      title: 'Велосипед горный',
      description: 'Горный велосипед в отличном состоянии. Подходит для городских поездок и легких трасс.',
      category: 'Спорт',
      pricePerDay: 800,
      deposit: 15000,
      ownerId: 'owner2',
      ownerName: 'Мария Сидорова',
      ownerRating: 4.9,
      location: 'Санкт-Петербург',
      images: [],
    ),
    Item(
      id: '3',
      title: 'Дрон DJI Mavic 3',
      description: 'Профессиональный дрон с камерой 4K. В комплекте запасные батареи и чехол.',
      category: 'Электроника',
      pricePerDay: 3000,
      deposit: 80000,
      ownerId: 'owner3',
      ownerName: 'Алексей Козлов',
      ownerRating: 4.7,
      location: 'Москва',
      images: [],
    ),
    Item(
      id: '4',
      title: 'Палатка 4-местная',
      description: 'Просторная палатка для кемпинга. Водонепроницаемая, легкая в установке.',
      category: 'Туризм',
      pricePerDay: 500,
      deposit: 8000,
      ownerId: 'owner4',
      ownerName: 'Елена Волкова',
      ownerRating: 4.6,
      location: 'Казань',
      images: [],
    ),
    Item(
      id: '5',
      title: 'Проектор Epson',
      description: 'Домашний проектор для просмотра фильмов. Разрешение Full HD.',
      category: 'Электроника',
      pricePerDay: 1200,
      deposit: 30000,
      ownerId: 'owner5',
      ownerName: 'Дмитрий Соколов',
      ownerRating: 4.5,
      location: 'Новосибирск',
      images: [],
    ),
  ];

  List<Item> getAllItems() {
    return _items;
  }

  List<Item> searchItems(String query) {
    if (query.isEmpty) return _items;
    
    final lowerQuery = query.toLowerCase();
    return _items.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
          item.description.toLowerCase().contains(lowerQuery) ||
          item.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Item? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

