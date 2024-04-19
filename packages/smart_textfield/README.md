# SmartTextField

SmartTextField is a TextInput that aims to parse valuable information from the user's input and make it easier to collect various types of data without breaking the user flow.

## Introduction

In traditional user interfaces, users often need to navigate through multiple input fields to provide different types of information, which can disrupt the flow and lead to a suboptimal user experience. SmartTextField addresses this issue by allowing users to enter all the required information in a single text field, using a natural language format.

## Use Case

For instance, in a task management app, if a user wants to provide the due date, project, and priority for a task, they can simply type all the information in the text field as a normal, readable text in one flow. Instead of having separate input fields for each piece of information, the user can enter something like: Buy groceries tomorrow @personal #p2
SmartTextField will then parse and extract the relevant information from the user's input text:

- Due date: `tomorrow`
- Project: `personal`
- Priority: `p2`

## Implementation

SmartTextField achieves this functionality by providing a set of patterns and possible values to the client. The client implements a `Tokenizer` component, which has the following properties:

1. **pattern**: A regular expression used to match patterns in the user's input text and invoke a list of possible values.
2. **values**: A list of values that will be shown to the user if a pattern is matched.
3. **token**: The extracted value from the user's input, based on the matched pattern and the selected value.

The client can define multiple `Tokenizer` instances, each with its own pattern, values, and token, to handle different types of information (e.g., dates, projects, priorities, etc.).

## Benefits

- **Streamlined User Experience**: Users can enter all the required information in a single, continuous flow, without the need to navigate between multiple input fields.
- **Natural Language Input**: Users can express information using natural language, making the input process more intuitive and user-friendly.
- **Customizable Patterns and Values**: Clients can define their own patterns and possible values based on their specific requirements, making SmartTextField highly flexible and adaptable.
- **Structured Data Extraction**: SmartTextField extracts structured data from the user's input text, making it easier to process and integrate with other components of the application.

## Getting Started

To use SmartTextField in your project, follow these steps:

1. Import the necessary dependencies and components.
2. Define your `Tokenizer` instances with the desired patterns, values, and tokens.
3. Implement the SmartTextField component in your user interface, passing the defined `Tokenizer` instances as props.
4. Handle the extracted tokens and use them in your application logic as needed.

For more detailed instructions and examples, please refer to the project's documentation.
