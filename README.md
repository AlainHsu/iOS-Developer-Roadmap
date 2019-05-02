# iOS Developer Roadmap

## Table of contents
<!-- MarkdownTOC -->

- [iOS Development Technology](#ios-development-technology)
    - [UI](#ui)
    - [Objective-C language](#objective-c-language)
    - [Runtime](#runtime)
    - [Memory management](#memory-management)
    - [Block](#block)
    - [MultiThreading](#multithreading)
    - [RunLoop](#runloop)
    - [Network](#network)
    - [Design patterns](#design-patterns)
    - [Architecture patterns](#architecture-patterns)
    - [Algorithm](#algorithm)
    - [Third-party libraries](#third-party-libraries)
- [Development Process](#development-process)
    - [Full App Development Process](#full-app-development-process)
    - [SDK Release Process](#sdk-release-process)
    - [Development](#development)
- [Development Tools](#development-tools)

<!-- /MarkdownTOC -->


## iOS Development Technology
![ESSENTIAL ROADMAP](ESSENTIALROADMAP.png)
### UI
- //TODO

### Objective-C language
- //TODO

### Runtime
- //TODO

### Memory management
- //TODO

### Block
- //TODO

### MultiThreading
- //TODO

### RunLoop
- //TODO

### Network
- //TODO

### Design patterns
- //TODO

### Architecture patterns
- //TODO

### Algorithm
- //TODO

### Third-party libraries
- //TODO

## Development Process
### Full App Development Process
- Project Kickoff
    - Responsibility Matrix
        + Sign-off with all involved parties
    - High Level Product Requirement Documents
        + Feature list
        + UI Concepts / Wireframe / UI design first draft
        + Sign-off by Customer
    - Timeline -  Milestones
        + Aligned with product schedule
        + Sign-off by SW PM
    - Resource allocation
       + Sign-off by SW PM
- Pre-Alpha
    - Technical Design Document
        + High level technical design
        + First draft
     - Test Plan
- Alpha
    - UI/UX Review Cycle 
        + Customer / UI/UX designer review and feedback
     - QA Cycle
- Beta
    - Feature freeze
    - IOP(interoperability) Plan
- Goldmaster
    - IOP(interoperability) report
    - Known issues list
    - Code freeze
    - Apple App Store approval materials
    - App store / Google Play Store / Amazon App Store metadata and artworks
    - Distribution Certificate
    - Stakeholders sign off

### SDK Release Process
- SDK Alpha Release (Initial release for Developer Preview. Multiple cycle)
    1. SDK libraries 

- SDK Beta Release (APIs freeze. Document stable. Could be Multple cycles)¶
    1. SDK Libraries
    2. APIs / Interface Document
    3. Programming Guide (with specification)

- SDK Final Release (Stable release)
    1. SDK Libraries
    2. API / Interface Document
    3. Programming Guide (With specification)
    4. Technical Design Document

### Development
- [Code Standard](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html)
- [Versioning](https://semver.org)
- Source Control Management (Version Control)
    + Commit Often
    + Push Often
    + Always left master as the stable branch. NEVER DEVELOP ON MASTER.
- Unit Testing
    + [OCMock for Objective-C](http://ocmock.org)
- Documentation
    + [AppleDoc](http//github.com/tomaz/appledoc.git)
    + [C4 model for visualising software architecture](https://c4model.com)
- Continuous Integration / Continuous Deployment
    + Jenkins

## Development Tools
### Environment
- [VPS+Shadowsocks](https://teddysun.com/486.html)
"Across the Great Wall we can reach every corner of the world."

### Development
- [Postman](https://www.getpostman.com)
A tool to debug and test the RESTful API.
- [APNS-Tool](https://itunes.apple.com/cn/app/apns-tool/id963558865?l=en&mt=12)
A simple application to test Apple Push Notification Service (APNS).
- [Charles](https://www.charlesproxy.com)
Charles is an HTTP proxy / HTTP monitor / Reverse Proxy that enables a developer to view all of the HTTP and SSL / HTTPS traffic between their machine and the Internet. This includes requests, responses and the HTTP headers (which contain the cookies and caching information).

### Documentation
- [Markdown](https://github.com/younghz/Markdown)
 A plain text formatting syntax designed so that it can optionally be converted to HTML.
- [Sublime Text](https://github.com/jikeytang/sublime-text)
A sophisticated text editor for code, markup and prose.
- [Web sequence diagram](https://www.websequencediagrams.com)
An online web tool to generate sequence diagram.

