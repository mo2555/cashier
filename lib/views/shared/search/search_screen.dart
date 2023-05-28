import 'package:cashier/helper/extensions.dart';
import 'package:cashier/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ItemsProvider>(context, listen: false).resetItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, provider, _) {
      return Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: provider.controller,
                              onSubmitted: (value) {},
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (provider.controller.text.isNotEmpty) {
                                provider.getItem(
                                    int.parse(provider.controller.text));
                              }
                            },
                            icon: const Icon(Icons.search_rounded),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (provider.searchItem != null)
                      Expanded(
                        child: InteractiveViewer(
                          constrained: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              3,
                              (index) => index == 0
                                  ? Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: List.generate(
                                          provider.header2.length,
                                          (inner) => Container(
                                            width: 22.appWidth(context),
                                            margin: inner == 0
                                                ? const EdgeInsets.only(left: 8)
                                                : null,
                                            child:
                                                provider.header2.length == inner
                                                    ? null
                                                    : Text(
                                                        provider.header2[inner],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : index == 1
                                      ? const SizedBox(
                                          height: 12,
                                        )
                                      : TextButton(
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.all(0),
                                            ),
                                          ),
                                          onPressed: () {
                                            provider.addToInvoice(
                                                provider.searchItem!);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                            ),
                                            child: Row(
                                              children: List.generate(
                                                4,
                                                (inner) => Container(
                                                  width: 22.appWidth(context),
                                                  margin: inner == 0
                                                      ? const EdgeInsets.only(
                                                          left: 8)
                                                      : null,
                                                  child: inner == 0
                                                      ? Text(
                                                          provider.searchItem!
                                                              .description,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        )
                                                      : Text(
                                                          '\$ ${inner == 1 ? provider.searchItem!.unitPrice : inner == 2 ? provider.searchItem!.vat : provider.searchItem!.unitPrice - provider.searchItem!.vat}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
          if (provider.getItemLoading)
            Container(
              color: Colors.black12,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
        ],
      );
    });
  }
}
