
class OnError {
  final int?  status;
  final String message;
  final String type;
  final String? source;
  OnError({
    this.status,
    required this.message,
    required this.type,
    this.source,
  });

  factory OnError.fromJson(Map<String,dynamic> json, String? recurso){
    return OnError(status: json['status'],type: json['error']['type'],message: json['error']['message'],source: recurso);
  }
}