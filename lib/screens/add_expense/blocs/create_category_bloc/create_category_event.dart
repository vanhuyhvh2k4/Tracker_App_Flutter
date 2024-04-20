part of 'create_category_bloc.dart';

sealed class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CreateCategoryEvent {
  final Category category;

  CreateCategory(this.category);

  @override
  // TODO: implement props
  List<Object> get props => [category];
}
