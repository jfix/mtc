# MTC HTML generation

## How-to

- Install Python and Pip (don't forget proxy settings!)
  - `G:\>set http_proxy=http://[proxy.server]:80`
  - `G:\>set https_proxy=http://[proxy.server]:80`
  - use `--trusted-host pypi.org --trusted-host files.pythonhosted.org`
- Install Mkdocs
- Install Material for Mkdocs
- Clone this repository
- Copy the two missing content files
- Run `xslt/xml-to-markdown.xslt` to generate Markdown output
- `mkdocs serve` to run development server
- `mkdocs build` to create standalone copy of the site
- Improve the XSLT to produce high-fidelity output


## Table of contents

- Frontmatter
  - Title, subtitle, author, date...
  - Page 2 (disclaimer, citation)
  - Foreword
  - Acknowledgement
-----
- Vol I
  - Introduction - I    
    - Introduction paras   
    - Intro A
    - Intro B
    - Intro C
    - [Intro D is missing?!]
  - Model Convention - M
    - Chapter 1 = 7
  - Commentaries - C
    - Commentaries 1 - 32
  - Positions - P
    - Intro
    - Positions 1 - 30
----
- Vol II
  - Foreword
  - Reports - R
    - Previous reports
    - Reports 1 - 26
  - Appendix - A
