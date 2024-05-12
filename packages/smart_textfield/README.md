## SmartTextField - Capture information seamlessly with natural language input 🗣️

SmartTextField is a TextInput that aims to extract valuable information seamlessly from raw text, making it easier to collect various types of data without breaking the user flow. 🚀

![SmartTextField Demo](https://raw.githubusercontent.com/Yogi-7y/Project-Y/main/assets/smart_textfield/smart_textfield_demo.gif)

## 🌟 Introduction

In traditional user interfaces, users often need to navigate through multiple input fields to provide different types of information, which can disrupt the flow and lead to a suboptimal user experience. 😩 SmartTextField addresses this issue by allowing users to enter all the required information in a single text field, using a natural language format. 🤯

## 💡 Use Case

For instance, in a task management app, if a user wants to provide the due date, project, and priority for a task, they can simply type all the information in the text field as a normal, readable text in one flow. Instead of having separate input fields for each piece of information, the user can enter something like: _"Buy groceries tomorrow @personal #p2"_ 🛒

SmartTextField will then parse and extract the relevant information from the user's input text:

- Due date: `tomorrow` 📆
- Project: `personal` 💼
- Priority: `p2` ⚠️

## 🛠️ Implementation

SmartTextField achieves this functionality by taking a set of patterns and possible values from the client. The client implements a `Tokenizer` component, which has the following properties:

1. **pattern**: A regular expression used to match patterns in the user's input text and invoke a list of possible values. 🔍
2. **values**: A list of values that will be shown to the user if a pattern is matched. Fuzzy matching can be used to find the closest value to the user's input. Value can be any type and must implement `Tokenable`. 🔢

```dart
@immutable
class Project implements Tokenable {
  const Project({required this.name});

  final String name;

  @override
  String get prefix => ProjectTokenizer.prefixId;

  @override
  String get stringValue => name;
}

class ProjectTokenizer extends Tokenizer<Project> {
  ProjectTokenizer({
    required super.values,
    super.prefix = prefixId,
  });

  static const prefixId = '@';
}

const _projects = <Project>[
  Project(name: 'Run a marathon'),
  Project(name: 'Learn to code'),
  Project(name: 'Write a book'),
  Project(name: 'House renovation'),
  Project(name: 'Travel to Japan'),
  Project(name: 'Learn to play the guitar'),
];

```

The client can define multiple `Tokenizer` instances, each with its own pattern & values, to handle different types of information (e.g., dates, projects, priorities, etc.) and pass it to the `SmartTextFieldController`. 🎛️

```dart
final _controller = SmartTextFieldController(
  tokenizers: [
    ProjectTokenizer(values: _projects),
  ],
);

return SmartTextField(
  controller: _controller,
  decoration: InputDecoration(
    hintText: 'Enter your task...',
  ),
);

```

### 📖 Reading Extracted Values

`highlightedTokens` stores a list of extracted values from the raw text. To listen for latest changes, attach a listener on `initState`. 👂

```dart
@override
void initState() {
  super.initState();
  _controller.highlightedTokens.addListener(_onHighlightedTokensChanged);
}

void _onHighlightedTokensChanged() {
  final _extractedTime = _controller.highlightedDateTime; /// Returns the extracted DateTime from the raw text. 🕰️

  final highlightedTokens = _controller.highlightedTokens.value; /// Map of extracted tokens that can be looked up by their prefix. 🗝️

  final _project = highlightedTokens[ProjectTokenizer.prefixId];
}
```

## 🚀 Benefits

- **Streamlined User Experience**: Users can enter all the required information in a single, continuous flow, without the need to navigate between multiple input fields. 🏃‍♀️
- **Natural Language Input**: Users can express information using natural language, making the input process more intuitive and user-friendly. 🗣️
- **Customizable Patterns and Values**: Clients can define their own patterns and possible values based on their specific requirements, making SmartTextField highly flexible and adaptable. 🔧

Ready to take your app's user experience to the next level? Give SmartTextField a try! 🎉
