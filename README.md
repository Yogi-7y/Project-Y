# Project Y 🚀

A mono repo of tools to help quick start a project by having basic setup already in place and ready to use.

## 📦 Packages

| Package | Description |
|---------|-------------|
| [network_y](packages/network/README.md) | A flexible networking abstraction that supports pluggable HTTP clients, enabling clean separation between your app and its network implementation.
| [core_y](packages/core/README.md) | Collection of essential utilities, common types, and extensions designed to standardize core functionality across projects. |
| [lints_y](packages/lints/README.md) | Curated set of lint rules to maintain code quality and consistency. |

## 💭 The Story Behind

Often while starting on a new side project, I caught myself doing the same setup and copying the same files repeatedly. Things like networking, core utilities, lints, error handling etc. 

What made it more challenging was when there were breaking changes, and since I was working on multiple projects, I had to ensure applying the same fix in each of them.

I just wanted to quickly build and try out my ideas. That's when I thought of creating this repository which is an attempt to abstract these common patterns and make them ready to use. The goal is simple - spend less time in repetitive stuff and focus directly on building.

The idea is to keep these packages minimal and very abstract, ensuring most of these are dart-only. It should provide an abstract layer for the apps using this and provide pluggable implementations if required, which most apps anyway do when working with external dependencies.