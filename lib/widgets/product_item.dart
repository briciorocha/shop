import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Excluir Produto'),
                        content: Text('Quer realmente remover este item?'),
                        actions: [
                          TextButton(
                            child: Text('Não'),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Sim'),
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                          )
                        ],
                      );
                    }).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(product.id);
                    } catch (error) {
                      scaffoldMessenger.showSnackBar(SnackBar(
                          content: Text(
                        error.toString(),
                        style: TextStyle(color: Colors.amber),
                      )));
                    }
                  }
                });
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
