enum Category { Skincare, Makeup, Haircare, Accessories, Perfume }



extension CategoryExtension on Category { 
  String get label {
    switch (this) {
      case Category.Skincare:
        return "Skincare";
      case Category.Makeup:
        return "Makeup";
      case Category.Haircare:
        return "Haircare";
      case Category.Accessories:
        return "Accessories";
      case Category.Perfume:
        return "Perfume";
    }
  }
}