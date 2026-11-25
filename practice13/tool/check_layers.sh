#!/bin/bash
# Layer rule: prints nothing when the layers are respected.
cd "$(dirname "$0")/.."

# package:http is allowed only in core/api and in *_repository.dart
grep -rl "package:http" lib/ | grep -v -e core/api -e _repository.dart

# package:flutter/material is forbidden in models, repositories and core/api
grep -rl "package:flutter/material" lib/ | grep -e _model.dart -e _repository.dart -e core/api

exit 0