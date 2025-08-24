import 'package:dartz/dartz.dart';
import '../../../../core/handlers/error-handler/error_handler.dart';
import 'package:hiracosmetics/features/product/data/data-source/product_data_source.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/domain/repositories/product_repo.dart';
class ProductRepoImpl implements ProductRepo {
  final ProductDataSource productDataSource;

  ProductRepoImpl({required this.productDataSource});
  @override
  Future<Either<String, Unit>> addProduct(Product product) async{
    try{
      await productDataSource.addProduct(product);
      return const Right(unit);
    }catch(e, stackTrace){
      final message =  handleError(e, stackTrace);
      return Left(message);
    }
  }

  @override
  Future<Either<String, List<Product>>> getProducts() async{
   try{
      final products = await productDataSource.getProducts();
      return Right(products);
   }catch(e, stackTrace){
      final message =  handleError(e, stackTrace);
      return Left(message);
   }
  }

  @override
  Future<Either<String, Unit>> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<String, Unit>> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }
  
  @override
  Future<Either<String, Map<String, dynamic>>> dailyStats() async{
    try{
      final stats = await productDataSource.dailyStats();
      return Right(stats);
    }catch(e, stackTrace){
      final message =  handleError(e, stackTrace);
      return Left(message);
    }
  }
  
  @override
  Future<Either<String, Unit>> sellProduct({
    required String productId,
    required int quantitySold,
    required double sellingPrice,
  }) async {
    try {
      await productDataSource.sellProduct(
        productId: productId,
        quantitySold: quantitySold,
        sellingPrice: sellingPrice,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }
  
  @override
  Future<Either<String, List<Product>>> getSoldProducts() async{
    try {
      final products = await productDataSource.getSoldProducts();
      return Right(products);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

  // get monthly stats with month
  @override
  Future<Either<String, Map<String, dynamic>>> monthlyStats(int month) async {
    try {
      final stats = await productDataSource.monthlyStats(month);
      return Right(stats);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

  @override
  Future<Either<String, List<Product>>> mostSoldProducts(int month) async {
    try {
      final products = await productDataSource.mostSoldProducts(month);
      return Right(products);
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      return Left(message);
    }
  }

}