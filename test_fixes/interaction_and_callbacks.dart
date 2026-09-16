// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_interaction_and_callbacks.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:kalender/kalender.dart';

CreateEventGesture? annotation;
CreateEventGesture value = CreateEventGesture.tap;

KalenderInteraction interaction() => KalenderInteraction(
  createEventGesture: CreateEventGesture.tap,
  modifyEventGesture: CreateEventGesture.longPress,
);

OnTappedWithDetails? onTapped;
OnLongPressedWithDetails? onLongPressed;
