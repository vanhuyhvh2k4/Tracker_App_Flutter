import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tracker_app/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:uuid/uuid.dart';

getCategoryCreation(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpended = false;
      String iconSelected = "";
      late Color categoryColor = Colors.white;
      TextEditingController categoryNameController = TextEditingController();
      TextEditingController categoryIconController = TextEditingController();
      TextEditingController categoryColorController = TextEditingController();

      List<String> myCategoriesIcons = [
        'entertainment',
        'food',
        "home",
        "pet",
        "shopping",
        "tech",
        "travel"
      ];

      bool isLoading = false;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(builder: (ctx, setState) {
          return BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(ctx);
              } else if (state is CreateCategoryLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: StatefulBuilder(builder: (ctx, setState) {
              return AlertDialog(
                title: const Text("Create a category"),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: categoryNameController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              isExpended = !isExpended;
                            });
                          },
                          controller: categoryIconController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              suffixIcon: const Icon(
                                CupertinoIcons.chevron_down,
                                size: 12,
                              ),
                              fillColor: Colors.white,
                              hintText: "Icon",
                              border: OutlineInputBorder(
                                  borderRadius: isExpended
                                      ? const BorderRadius.vertical(
                                          top: Radius.circular(12))
                                      : BorderRadius.circular(12),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      isExpended
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5),
                                    itemCount: myCategoriesIcons.length,
                                    itemBuilder: (context, int i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              iconSelected =
                                                  myCategoriesIcons[i];
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: iconSelected ==
                                                          myCategoriesIcons[i]
                                                      ? Colors.green
                                                      : Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/${myCategoriesIcons[i]}.png'))),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: categoryColorController,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ColorPicker(
                                        pickerColor: categoryColor,
                                        onColorChanged: (value) {
                                          setState(() {
                                            categoryColor = value;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx2);
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12))),
                                            child: const Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: categoryColor,
                            hintText: "Color",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      isLoading = true;
                                    },
                                  );

                                  Category category = Category.empty;
                                  category.categoryId = const Uuid().v1();
                                  category.name = categoryNameController.text;
                                  category.icon = iconSelected;
                                  category.color = categoryColor.value;
                                  context
                                      .read<CreateCategoryBloc>()
                                      .add(CreateCategory(category));
                                  // Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      );
    },
  );
}
