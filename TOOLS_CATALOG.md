# Homebrew ARM64 Migration - Tools Catalog

> A comprehensive reference guide for all tools supported by the installation script

## Overview

This catalog documents all **72 tools** that can be installed using the [install-homebrew-arm64.sh](./install-homebrew-arm64.sh) script. Each tool includes a description, official links, and category information to help you make informed decisions about your development environment.

### Quick Stats

- **Total Tools**: 72
- **Essential Tools**: 19 (auto-installed)
- **Version Managers**: 8
- **Programming Languages**: 5
- **Cloud & DevOps**: 11
- **Build Tools**: 8
- **Modern CLI Tools**: 10
- **Database Clients**: 2
- **Media Processing**: 4
- **GUI Applications**: 5

---

## Table of Contents

1. [Essential Tools](#essential-tools) - Auto-installed development essentials
2. [Version Managers](#version-managers) - Manage multiple language versions
3. [Programming Languages](#programming-languages) - Language runtimes and compilers
4. [Cloud & DevOps](#cloud--devops) - Cloud platforms and container orchestration
5. [Build Tools](#build-tools) - Compilation and build automation
6. [Modern CLI Tools](#modern-cli-tools) - Enhanced Unix command replacements
7. [Database Clients](#database-clients) - Database connection libraries
8. [Media Processing](#media-processing) - Image, video, and audio tools
9. [GUI Applications](#gui-applications) - Desktop applications (casks)
10. [Quick Reference Table](#quick-reference-table)

---

## Essential Tools

*Auto-installed in Phase 2 - Core development tools that most developers need*

### bat

**Better Cat with Syntax Highlighting**

A cat clone with syntax highlighting, Git integration, automatic paging, and line numbers. Modern replacement for the traditional `cat` command.

- 🌐 Website: https://github.com/sharkdp/bat
- 📦 GitHub: https://github.com/sharkdp/bat
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Makes reading files in terminal much more pleasant with syntax highlighting and Git diff integration

### ca-certificates

**SSL/TLS Certificate Bundle**

A collection of trusted Certificate Authority (CA) certificates for SSL/TLS verification, essential for secure HTTPS connections.

- 🌐 Website: https://curl.se/docs/caextract.html
- **Phase**: 2 (Essential Tools - Auto)

### coreutils

**GNU Core Utilities**

GNU implementations of basic Unix commands (ls, cat, chmod, etc.) with additional features and consistent behavior across platforms.

- 🌐 Website: https://www.gnu.org/software/coreutils/
- **Phase**: 2 (Essential Tools - Auto)

### curl

**Command-line HTTP Client**

A command-line tool for transferring data with URLs, supporting HTTP, HTTPS, FTP, and many other protocols. Essential for API testing and downloads.

- 🌐 Website: https://curl.se
- 📦 GitHub: https://github.com/curl/curl
- **Phase**: 2 (Essential Tools - Auto)

### diff-so-fancy

**Better Git Diffs**

A Git diff output formatter that makes diffs human-readable with better colors, cleaner formatting, and improved readability.

- 🌐 Website: https://github.com/so-fancy/diff-so-fancy
- 📦 GitHub: https://github.com/so-fancy/diff-so-fancy
- **Phase**: 2 (Essential Tools - Auto)

### git

**Distributed Version Control System**

The world's most popular version control system for tracking changes in source code, enabling collaboration, and managing software development workflows.

- 🌐 Website: https://git-scm.com
- 📦 GitHub: https://github.com/git/git
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Industry-standard version control - essential for all modern development

### git-lfs

**Git Large File Storage**

Git extension for versioning large files by replacing them with text pointers while storing the actual files on a remote server.

- 🌐 Website: https://git-lfs.com
- 📦 GitHub: https://github.com/git-lfs/git-lfs
- **Phase**: 2 (Essential Tools - Auto)

### gh

**GitHub CLI**

Official GitHub command-line tool for managing pull requests, issues, releases, and workflows directly from your terminal.

- 🌐 Website: https://cli.github.com
- 📦 GitHub: https://github.com/cli/cli
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Streamlines GitHub workflows without leaving the terminal

### grep

**Pattern Matching Tool**

GNU grep implementation for searching text using regular expressions. More feature-complete than macOS's built-in BSD grep.

- 🌐 Website: https://www.gnu.org/software/grep/
- **Phase**: 2 (Essential Tools - Auto)

### htop

**Interactive Process Viewer**

An interactive process viewer and system monitor, providing a colorful and more user-friendly alternative to the traditional `top` command.

- 🌐 Website: https://htop.dev
- 📦 GitHub: https://github.com/htop-dev/htop
- **Phase**: 2 (Essential Tools - Auto)

### jq

**JSON Processor**

A lightweight command-line JSON processor for parsing, filtering, and transforming JSON data with a powerful query language.

- 🌐 Website: https://jqlang.github.io/jq/
- 📦 GitHub: https://github.com/jqlang/jq
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Essential for working with APIs and JSON config files

### mas

**Mac App Store CLI**

Command-line interface for the Mac App Store, allowing you to search, install, and update Mac App Store applications from the terminal.

- 🌐 Website: https://github.com/mas-cli/mas
- 📦 GitHub: https://github.com/mas-cli/mas
- **Phase**: 2 (Essential Tools - Auto)

### nmap

**Network Scanner**

Network exploration and security auditing tool for discovering hosts, services, and security vulnerabilities on networks.

- 🌐 Website: https://nmap.org
- 📦 GitHub: https://github.com/nmap/nmap
- **Phase**: 2 (Essential Tools - Auto)

### openssl@3

**SSL/TLS Cryptography Library**

Industry-standard cryptography library for secure communications, providing SSL/TLS protocols and cryptographic functions.

- 🌐 Website: https://www.openssl.org
- 📦 GitHub: https://github.com/openssl/openssl
- **Phase**: 2 (Essential Tools - Auto)

### sqlite

**Embedded SQL Database**

A self-contained, serverless SQL database engine used by countless applications. Perfect for local development and embedded systems.

- 🌐 Website: https://www.sqlite.org
- 📦 GitHub: https://github.com/sqlite/sqlite
- **Phase**: 2 (Essential Tools - Auto)

### tldr

**Simplified Man Pages**

Community-maintained simplified and community-driven man pages, providing practical examples for common command-line tools.

- 🌐 Website: https://tldr.sh
- 📦 GitHub: https://github.com/tldr-pages/tldr
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Get quick, practical examples without reading lengthy man pages

### tree

**Directory Tree Visualizer**

Displays directory structures in a tree format, making it easy to visualize file hierarchies and project structures.

- 🌐 Website: https://oldmanprogrammer.net/source.php?dir=projects/tree
- **Phase**: 2 (Essential Tools - Auto)

### wget

**File Download Utility**

Non-interactive network downloader supporting HTTP, HTTPS, and FTP, ideal for scripted downloads and mirroring websites.

- 🌐 Website: https://www.gnu.org/software/wget/
- 📦 GitHub: https://git.savannah.gnu.org/cgit/wget.git
- **Phase**: 2 (Essential Tools - Auto)

### yq

**YAML Processor**

A lightweight command-line YAML, JSON, and XML processor similar to jq but designed for YAML files.

- 🌐 Website: https://mikefarah.gitbook.io/yq/
- 📦 GitHub: https://github.com/mikefarah/yq
- **Phase**: 2 (Essential Tools - Auto)
- **Why use this?** Essential for working with Kubernetes configs and YAML-based tools

---

## Version Managers

*Manage multiple versions of programming languages and tools*

### fnm

**Fast Node Manager**

Fast and simple Node.js version manager built in Rust, providing 40x faster performance than nvm with cross-platform support.

- 🌐 Website: https://github.com/Schniz/fnm
- 📦 GitHub: https://github.com/Schniz/fnm
- **Phase**: 3 (Version Managers)
- **Why use this?** Modern nvm replacement - dramatically faster, especially on Apple Silicon

### opentofu

**Open-Source Terraform Fork**

Community-driven, open-source Terraform fork created after HashiCorp's license change. 100% compatible with Terraform configuration files.

- 🌐 Website: https://opentofu.org
- 📦 GitHub: https://github.com/opentofu/opentofu
- **Phase**: 3 (Version Managers)
- **Why use this?** Open-source alternative to Terraform after BSL license change

### pyenv

**Python Version Manager**

Simple Python version manager for installing and switching between multiple Python versions on a single system.

- 🌐 Website: https://github.com/pyenv/pyenv
- 📦 GitHub: https://github.com/pyenv/pyenv
- **Phase**: 3 (Version Managers)

### rbenv

**Ruby Version Manager**

Lightweight Ruby version manager that integrates seamlessly with the shell, providing simple and transparent version switching.

- 🌐 Website: https://github.com/rbenv/rbenv
- 📦 GitHub: https://github.com/rbenv/rbenv
- **Phase**: 3 (Version Managers)

### ruby-build

**Ruby Installation Plugin for rbenv**

An rbenv plugin that provides the `rbenv install` command for compiling and installing different versions of Ruby.

- 🌐 Website: https://github.com/rbenv/ruby-build
- 📦 GitHub: https://github.com/rbenv/ruby-build
- **Phase**: 3 (Version Managers)

### tfenv

**Terraform Version Manager**

Terraform and OpenTofu version manager inspired by rbenv, allowing easy switching between infrastructure-as-code tool versions.

- 🌐 Website: https://github.com/tfutils/tfenv
- 📦 GitHub: https://github.com/tfutils/tfenv
- **Phase**: 3 (Version Managers)

### uv

**Fast Python Package Installer and Resolver**

Extremely fast Python package installer and resolver written in Rust by Astral (creators of Ruff). Unified tool replacing pip, pipx, pyenv, virtualenv, and pip-tools.

- 🌐 Website: https://docs.astral.sh/uv/
- 📦 GitHub: https://github.com/astral-sh/uv
- **Phase**: 3 (Version Managers)
- **Why use this?** 10-100x faster than pip, manages Python versions + packages in one tool

### volta

**JavaScript Toolchain Manager**

Hassle-free JavaScript tool manager that automatically switches Node.js and package manager versions per project.

- 🌐 Website: https://volta.sh
- 📦 GitHub: https://github.com/volta-cli/volta
- **Phase**: 3 (Version Managers)
- **Why use this?** Best for teams - automatically uses correct Node version per project

---

## Programming Languages

*Language runtimes, compilers, and package managers*

### composer

**PHP Dependency Manager**

Dependency manager for PHP, similar to npm for Node.js or pip for Python, managing project libraries and dependencies.

- 🌐 Website: https://getcomposer.org
- 📦 GitHub: https://github.com/composer/composer
- **Phase**: 4 (Languages)

### go

**Go Programming Language**

Statically typed, compiled programming language designed for simplicity, reliability, and efficiency in building scalable systems.

- 🌐 Website: https://go.dev
- 📦 GitHub: https://github.com/golang/go
- **Phase**: 4 (Languages)
- **Note**: Script recommends official installer over Homebrew

### openjdk

**Open Java Development Kit**

Open-source implementation of the Java Platform, Standard Edition providing the Java runtime and development tools.

- 🌐 Website: https://openjdk.org
- **Phase**: 4 (Languages)
- **Note**: Script recommends SDKMAN over Homebrew for Java

### perl

**Perl Programming Language**

High-level, general-purpose programming language known for text processing, often required as a dependency for build tools.

- 🌐 Website: https://www.perl.org
- 📦 GitHub: https://github.com/Perl/perl5
- **Phase**: 4 (Languages)

### php

**PHP Programming Language**

Popular server-side scripting language designed for web development, powering millions of websites worldwide.

- 🌐 Website: https://www.php.net
- 📦 GitHub: https://github.com/php/php-src
- **Phase**: 4 (Languages)

---

## Cloud & DevOps

*Cloud platform CLIs, Kubernetes tools, and infrastructure automation*

### ansible

**IT Automation Platform**

Ansible is an open-source automation tool for configuration management, application deployment, and task automation using simple YAML playbooks.

- 🌐 Website: https://www.ansible.com
- 📦 GitHub: https://github.com/ansible/ansible
- **Phase**: 5 (Cloud & DevOps)

### ansible-lint

**Ansible Playbook Linter**

A command-line tool for linting Ansible playbooks, roles, and collections to enforce best practices and catch errors before deployment.

- 🌐 Website: https://ansible.readthedocs.io/projects/lint/
- 📦 GitHub: https://github.com/ansible/ansible-lint
- **Phase**: 5 (Cloud & DevOps)

### awscli

**AWS Command Line Interface**

Official command-line interface for Amazon Web Services, enabling management of AWS services from the terminal.

- 🌐 Website: https://aws.amazon.com/cli/
- 📦 GitHub: https://github.com/aws/aws-cli
- **Phase**: 5 (Cloud & DevOps)

### azure-cli

**Azure Command Line Interface**

Microsoft's official command-line tool for managing Azure resources and services.

- 🌐 Website: https://docs.microsoft.com/en-us/cli/azure/
- 📦 GitHub: https://github.com/Azure/azure-cli
- **Phase**: 5 (Cloud & DevOps)

### doppler

**Secrets Management CLI**

Universal secrets manager for developers, centralizing environment variables and secrets across teams and applications.

- 🌐 Website: https://www.doppler.com
- 📦 GitHub: https://github.com/DopplerHQ/cli
- **Phase**: 5 (Cloud & DevOps)

### google-cloud-sdk

**Google Cloud CLI**

Command-line interface for Google Cloud Platform services, providing tools like gcloud, gsutil, and bq.

- 🌐 Website: https://cloud.google.com/sdk
- 📦 GitHub: https://github.com/GoogleCloudPlatform/cloud-sdk-docker
- **Phase**: 5 (Cloud & DevOps)
- **Note**: Installed as a cask

### helm

**Kubernetes Package Manager**

Package manager for Kubernetes, simplifying deployment and management of applications using pre-configured charts.

- 🌐 Website: https://helm.sh
- 📦 GitHub: https://github.com/helm/helm
- **Phase**: 5 (Cloud & DevOps)

### k9s

**Kubernetes CLI Dashboard**

Terminal-based UI for managing Kubernetes clusters, providing a fast and interactive way to navigate and observe resources.

- 🌐 Website: https://k9scli.io
- 📦 GitHub: https://github.com/derailed/k9s
- **Phase**: 5 (Cloud & DevOps)
- **Why use this?** Makes Kubernetes management much easier with an intuitive TUI

### kubectl

**Kubernetes Command-Line Tool**

Official command-line interface for running commands against Kubernetes clusters and managing containerized applications.

- 🌐 Website: https://kubernetes.io/docs/reference/kubectl/
- 📦 GitHub: https://github.com/kubernetes/kubectl
- **Phase**: 5 (Cloud & DevOps)

### kubectx

**Kubernetes Context Switcher**

Fast way to switch between Kubernetes clusters and namespaces. Includes both kubectx (context switcher) and kubens (namespace switcher).

- 🌐 Website: https://github.com/ahmetb/kubectx
- 📦 GitHub: https://github.com/ahmetb/kubectx
- **Phase**: 5 (Cloud & DevOps)
- **Note**: Includes kubens (namespace switcher)

### stern

**Multi-Pod Log Tailing for Kubernetes**

Tail logs from multiple Kubernetes pods and containers simultaneously with color-coded output for easy debugging.

- 🌐 Website: https://github.com/stern/stern
- 📦 GitHub: https://github.com/stern/stern
- **Phase**: 5 (Cloud & DevOps)

---

## Build Tools

*Compilation, build automation, and development toolchains*

### autoconf

**GNU Build System Generator**

Tool for producing shell scripts that automatically configure software source code packages for various Unix-like systems.

- 🌐 Website: https://www.gnu.org/software/autoconf/
- **Phase**: 6 (Build Tools)

### automake

**Makefile Generator**

Tool for automatically generating Makefile.in files from Makefile.am templates, working with autoconf to simplify builds.

- 🌐 Website: https://www.gnu.org/software/automake/
- **Phase**: 6 (Build Tools)

### bison

**Parser Generator**

GNU general-purpose parser generator converting grammar descriptions into C/C++ parsers, compatible with Yacc.

- 🌐 Website: https://www.gnu.org/software/bison/
- **Phase**: 6 (Build Tools)

### cmake

**Cross-Platform Build System**

Cross-platform build system generator supporting multiple native build environments and compilers for C, C++, and other languages.

- 🌐 Website: https://cmake.org
- 📦 GitHub: https://github.com/Kitware/CMake
- **Phase**: 6 (Build Tools)

### libtool

**Generic Library Support Script**

Script that hides the complexity of using shared libraries behind a consistent, portable interface across platforms.

- 🌐 Website: https://www.gnu.org/software/libtool/
- **Phase**: 6 (Build Tools)

### m4

**Macro Processor**

Macro processor used by autoconf and other tools to generate configuration scripts and process text transformations.

- 🌐 Website: https://www.gnu.org/software/m4/
- **Phase**: 6 (Build Tools)

### make

**Build Automation Tool**

Classic build automation tool that controls the generation of executables from source code using Makefiles.

- 🌐 Website: https://www.gnu.org/software/make/
- **Phase**: 6 (Build Tools)

### pkg-config

**Library Compilation Helper**

Helper tool for inserting correct compiler and linker flags when building applications that depend on libraries.

- 🌐 Website: https://www.freedesktop.org/wiki/Software/pkg-config/
- 📦 GitHub: https://gitlab.freedesktop.org/pkg-config/pkg-config
- **Phase**: 6 (Build Tools)

---

## Modern CLI Tools

*Enhanced replacements for traditional Unix commands, written in Rust for speed*

### chezmoi

**Dotfiles Manager**

Manage your dotfiles across multiple machines securely using a single Git repository with templating support.

- 🌐 Website: https://www.chezmoi.io
- 📦 GitHub: https://github.com/twpayne/chezmoi
- **Phase**: 7 (Modern CLI Tools)

### eza

**Modern ls Replacement**

Modern replacement for ls with colors, icons, Git integration, and tree views. Fork of the unmaintained exa project.

- 🌐 Website: https://eza.rocks
- 📦 GitHub: https://github.com/eza-community/eza
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** Beautiful, informative file listings with Git status and icons

### fd

**Fast and User-Friendly Find**

Simple, fast, and user-friendly alternative to find, with intuitive syntax and respecting .gitignore by default.

- 🌐 Website: https://github.com/sharkdp/fd
- 📦 GitHub: https://github.com/sharkdp/fd
- **Phase**: 7 (Modern CLI Tools)

### fzf

**Fuzzy Finder**

General-purpose command-line fuzzy finder that can be used for files, command history, processes, and more.

- 🌐 Website: https://github.com/junegunn/fzf
- 📦 GitHub: https://github.com/junegunn/fzf
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** Revolutionary workflow improvement for searching files and history

### git-delta

**Better Git Diffs**

Syntax-highlighting pager for Git, diff, and grep output with line numbers, side-by-side view, and syntax highlighting.

- 🌐 Website: https://github.com/dandavison/delta
- 📦 GitHub: https://github.com/dandavison/delta
- **Phase**: 7 (Modern CLI Tools)

### httpie

**User-Friendly HTTP Client**

Human-friendly command-line HTTP client with expressive syntax, JSON support, and syntax highlighting.

- 🌐 Website: https://httpie.io
- 📦 GitHub: https://github.com/httpie/httpie
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** Much easier API testing than curl with readable syntax

### procs

**Modern ps Replacement**

Modern replacement for ps written in Rust, providing colorful output, tree view, and better information display.

- 🌐 Website: https://github.com/dalance/procs
- 📦 GitHub: https://github.com/dalance/procs
- **Phase**: 7 (Modern CLI Tools)

### ripgrep

**Fast Line-Oriented Search**

Extremely fast grep alternative that recursively searches directories, respects .gitignore, and supports Unicode.

- 🌐 Website: https://github.com/BurntSushi/ripgrep
- 📦 GitHub: https://github.com/BurntSushi/ripgrep
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** 10-100x faster than grep, respects .gitignore automatically

### tmux

**Terminal Multiplexer**

Terminal multiplexer enabling multiple terminal sessions in a single window, with session persistence and remote attachment.

- 🌐 Website: https://github.com/tmux/tmux
- 📦 GitHub: https://github.com/tmux/tmux
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** Essential for remote development and managing multiple terminal sessions

### zoxide

**Smarter cd Command**

Smarter cd command that learns your habits and jumps to frequently used directories with minimal typing.

- 🌐 Website: https://github.com/ajeetdsouza/zoxide
- 📦 GitHub: https://github.com/ajeetdsouza/zoxide
- **Phase**: 7 (Modern CLI Tools)
- **Why use this?** Never type long directory paths again - jump with a few characters

---

## Database Clients

*Client libraries for connecting to databases (not database servers)*

### libpq

**PostgreSQL C Client Library**

PostgreSQL client library containing header files and libraries for compiling C programs that connect to PostgreSQL.

- 🌐 Website: https://www.postgresql.org/docs/current/libpq.html
- **Phase**: 8 (Database Clients)

### mysql-client

**MySQL Command-Line Client**

Command-line client for MySQL and MariaDB databases, providing tools to connect and execute SQL queries.

- 🌐 Website: https://dev.mysql.com/doc/refman/8.0/en/mysql.html
- **Phase**: 8 (Database Clients)

---

## Media Processing

*Image, video, audio processing and conversion tools*

### ffmpeg

**Multimedia Framework**

Complete, cross-platform solution to record, convert, and stream audio and video, supporting virtually all codecs and formats.

- 🌐 Website: https://ffmpeg.org
- 📦 GitHub: https://github.com/FFmpeg/FFmpeg
- **Phase**: 9 (Media Processing)
- **Why use this?** Industry-standard for video/audio processing and conversion

### ghostscript

**PostScript and PDF Interpreter**

Interpreter for PostScript and PDF files, often used with ImageMagick for PDF manipulation and conversion.

- 🌐 Website: https://www.ghostscript.com
- 📦 GitHub: https://git.ghostscript.com/
- **Phase**: 9 (Media Processing)

### imagemagick

**Image Manipulation Suite**

Comprehensive image manipulation suite for converting, editing, and composing bitmap images in over 200 formats.

- 🌐 Website: https://imagemagick.org
- 📦 GitHub: https://github.com/ImageMagick/ImageMagick
- **Phase**: 9 (Media Processing)

### tesseract

**OCR Engine**

Open-source optical character recognition (OCR) engine that can extract text from images in 100+ languages.

- 🌐 Website: https://github.com/tesseract-ocr/tesseract
- 📦 GitHub: https://github.com/tesseract-ocr/tesseract
- **Phase**: 9 (Media Processing)

---

## GUI Applications

*Desktop applications installed via Homebrew Cask*

### alfred

**Productivity App for macOS**

Powerful Spotlight replacement with workflows, clipboard history, snippets, and deep system integration.

- 🌐 Website: https://www.alfredapp.com
- **Phase**: 10 (GUI Applications - Cask)
- **Why use this?** Dramatically boosts macOS productivity with workflows and automation

### caffeine

**Keep Mac Awake Utility**

Simple menu bar app that prevents your Mac from going to sleep, dimming the screen, or starting screen savers.

- 🌐 Website: https://intelliscapesolutions.com/apps/caffeine
- **Phase**: 10 (GUI Applications - Cask)

### cheatsheet

**Keyboard Shortcuts Display**

Hold the Command key to display all available keyboard shortcuts for the currently active application.

- 🌐 Website: https://www.mediaatelier.com/CheatSheet/
- **Phase**: 10 (GUI Applications - Cask)

### firefox

**Web Browser**

Free and open-source web browser developed by Mozilla Foundation, focused on privacy and web standards.

- 🌐 Website: https://www.mozilla.org/firefox/
- 📦 GitHub: https://github.com/mozilla/gecko-dev
- **Phase**: 10 (GUI Applications - Cask)

### iterm2

**Terminal Emulator for macOS**

Replacement for Terminal with advanced features like split panes, search, autocomplete, and extensive customization.

- 🌐 Website: https://iterm2.com
- 📦 GitHub: https://github.com/gnachman/iTerm2
- **Phase**: 10 (GUI Applications - Cask)
- **Why use this?** Much more powerful than built-in Terminal.app

---

## Quick Reference Table

| Tool | Category | Phase | Auto-Install |
|------|----------|-------|--------------|
| alfred | GUI Apps | 10 | ❌ |
| ansible | Cloud/DevOps | 5 | ❌ |
| ansible-lint | Cloud/DevOps | 5 | ❌ |
| autoconf | Build Tools | 6 | ❌ |
| automake | Build Tools | 6 | ❌ |
| awscli | Cloud/DevOps | 5 | ❌ |
| azure-cli | Cloud/DevOps | 5 | ❌ |
| bat | Essential | 2 | ✅ |
| bison | Build Tools | 6 | ❌ |
| ca-certificates | Essential | 2 | ✅ |
| caffeine | GUI Apps | 10 | ❌ |
| cheatsheet | GUI Apps | 10 | ❌ |
| chezmoi | Modern CLI | 7 | ❌ |
| cmake | Build Tools | 6 | ❌ |
| composer | Languages | 4 | ❌ |
| coreutils | Essential | 2 | ✅ |
| curl | Essential | 2 | ✅ |
| diff-so-fancy | Essential | 2 | ✅ |
| doppler | Cloud/DevOps | 5 | ❌ |
| eza | Modern CLI | 7 | ❌ |
| fd | Modern CLI | 7 | ❌ |
| ffmpeg | Media | 9 | ❌ |
| firefox | GUI Apps | 10 | ❌ |
| fnm | Version Managers | 3 | ❌ |
| fzf | Modern CLI | 7 | ❌ |
| gh | Essential | 2 | ✅ |
| ghostscript | Media | 9 | ❌ |
| git | Essential | 2 | ✅ |
| git-delta | Modern CLI | 7 | ❌ |
| git-lfs | Essential | 2 | ✅ |
| go | Languages | 4 | ❌ |
| google-cloud-sdk | Cloud/DevOps | 5 | ❌ |
| grep | Essential | 2 | ✅ |
| helm | Cloud/DevOps | 5 | ❌ |
| htop | Essential | 2 | ✅ |
| httpie | Modern CLI | 7 | ❌ |
| imagemagick | Media | 9 | ❌ |
| iterm2 | GUI Apps | 10 | ❌ |
| jq | Essential | 2 | ✅ |
| k9s | Cloud/DevOps | 5 | ❌ |
| kubectl | Cloud/DevOps | 5 | ❌ |
| kubectx | Cloud/DevOps | 5 | ❌ |
| libpq | Database | 8 | ❌ |
| libtool | Build Tools | 6 | ❌ |
| m4 | Build Tools | 6 | ❌ |
| make | Build Tools | 6 | ❌ |
| mas | Essential | 2 | ✅ |
| mysql-client | Database | 8 | ❌ |
| nmap | Essential | 2 | ✅ |
| openjdk | Languages | 4 | ❌ |
| openssl@3 | Essential | 2 | ✅ |
| opentofu | Version Managers | 3 | ❌ |
| perl | Languages | 4 | ❌ |
| php | Languages | 4 | ❌ |
| pkg-config | Build Tools | 6 | ❌ |
| procs | Modern CLI | 7 | ❌ |
| pyenv | Version Managers | 3 | ❌ |
| rbenv | Version Managers | 3 | ❌ |
| ripgrep | Modern CLI | 7 | ❌ |
| ruby-build | Version Managers | 3 | ❌ |
| sqlite | Essential | 2 | ✅ |
| stern | Cloud/DevOps | 5 | ❌ |
| tesseract | Media | 9 | ❌ |
| tfenv | Version Managers | 3 | ❌ |
| tldr | Essential | 2 | ✅ |
| tmux | Modern CLI | 7 | ❌ |
| tree | Essential | 2 | ✅ |
| uv | Version Managers | 3 | ❌ |
| volta | Version Managers | 3 | ❌ |
| wget | Essential | 2 | ✅ |
| yq | Essential | 2 | ✅ |
| zoxide | Modern CLI | 7 | ❌ |

---

## Notes

- **Phase 2 (Essential Tools)** are auto-installed without prompting
- All other phases require user confirmation before installation
- GUI Applications are installed as Homebrew Casks (`.app` bundles)
- Some tools (Java, Go) have installation method recommendations in the script

---

## Related Documentation

- [Installation Script](./install-homebrew-arm64.sh) - Main installation script
- [README.md](./README.md) - Project overview and usage guide
- [UNINSTALL.md](./UNINSTALL.md) - Uninstallation instructions

---

## Keeping This Catalog Updated

This catalog should be updated whenever:
1. New tools are added to the installation script
2. Tools are deprecated or removed
3. Official websites or GitHub repositories change
4. Tool descriptions need clarification

**Last Updated**: 2025-11-05

---

*Generated for Homebrew ARM64 Migration Tool - Making Apple Silicon development setup transparent and easy*
