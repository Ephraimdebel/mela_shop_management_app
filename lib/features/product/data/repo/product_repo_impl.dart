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
  Stream<Either<String, Map<String, dynamic>>> dailyStats() async* {
    try {
       yield* productDataSource.dailyStats().map((stats) => Right(stats));
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      yield Left(message);
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
  Stream<Either<String, List<Product>>> getSoldProducts() async* {
    try {
      yield* productDataSource.getSoldProducts().map((products) => Right(products));
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      yield Left(message);
    }
  }

  // get monthly stats with month
  @override
  Stream<Either<String, Map<String, dynamic>>> monthlyStats(int month) async* {
    try {
      yield* productDataSource.monthlyStats(month).map((stats) => Right(stats));
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      yield Left(message);
    }
  }

  @override
  Stream<Either<String, List<Product>>> mostSoldProducts(int month) async* {
    try {
      yield* productDataSource.mostSoldProducts(month).map((products) => Right(products));
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      yield Left(message);
    }
  }

  @override
  Stream<Either<String, Map<String, dynamic>>> categoryPerformance(int month) async* {
    try {
      yield* productDataSource.categoryPerformance(month).map((performance)=> Right(performance));
    } catch (e, stackTrace) {
      final message = handleError(e, stackTrace);
      yield Left(message);
    }
  }

}