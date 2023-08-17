class Request {
  String? model;
  String? prompt;
  int? maxTokens;
  double? temperature;
  int? n;

  Request({
    this.model,
    this.prompt,
    this.maxTokens,
    this.temperature,
    this.n,
  });
}
