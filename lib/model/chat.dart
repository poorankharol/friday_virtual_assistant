// To parse this JSON data, do
//
//     final chat = chatFromMap(jsonString);

import 'dart:convert';

Chat chatFromMap(String str) => Chat.fromMap(json.decode(str));

String chatToMap(Chat data) => json.encode(data.toMap());

class Chat {
  String warning;
  String id;
  String object;
  int created;
  String model;
  List<Choice> choices;
  Usage usage;

  Chat({
    required this.warning,
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(
    warning: json["warning"],
    id: json["id"],
    object: json["object"],
    created: json["created"],
    model: json["model"],
    choices: List<Choice>.from(json["choices"].map((x) => Choice.fromMap(x))),
    usage: Usage.fromMap(json["usage"]),
  );

  Map<String, dynamic> toMap() => {
    "warning": warning,
    "id": id,
    "object": object,
    "created": created,
    "model": model,
    "choices": List<dynamic>.from(choices.map((x) => x.toMap())),
    "usage": usage.toMap(),
  };
}

class Choice {
  String text;
  int index;
  dynamic logprobs;
  String finishReason;

  Choice({
    required this.text,
    required this.index,
    this.logprobs,
    required this.finishReason,
  });

  factory Choice.fromMap(Map<String, dynamic> json) => Choice(
    text: json["text"],
    index: json["index"],
    logprobs: json["logprobs"],
    finishReason: json["finish_reason"],
  );

  Map<String, dynamic> toMap() => {
    "text": text,
    "index": index,
    "logprobs": logprobs,
    "finish_reason": finishReason,
  };
}

class Usage {
  int promptTokens;
  int completionTokens;
  int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromMap(Map<String, dynamic> json) => Usage(
    promptTokens: json["prompt_tokens"],
    completionTokens: json["completion_tokens"],
    totalTokens: json["total_tokens"],
  );

  Map<String, dynamic> toMap() => {
    "prompt_tokens": promptTokens,
    "completion_tokens": completionTokens,
    "total_tokens": totalTokens,
  };
}
