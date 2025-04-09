sealed class BaseResult {} 

class BaseResultSuccess<T> extends BaseResult {
  final T data;
  BaseResultSuccess(this.data);
}
class BaseResultError extends BaseResult {
  final String message;
  BaseResultError(this.message);
}
