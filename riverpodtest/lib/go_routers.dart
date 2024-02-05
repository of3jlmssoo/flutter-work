import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'expencesscreenfs.dart';
import 'firebase_data_get.dart';
import 'main.dart';
import 'expenceinputfs.dart';

final GoRouter myRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        // GoRoute(
        //   path: 'listview',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return ReportsScreen();
        //   },
        // ),
        // GoRoute(
        //   name: 'expenceinput',
        //   path: 'expenceinput',
        //   builder: (context, state) => ExpenceInput(
        //     reportID: state.uri.queryParameters['reportID']!,
        //     userID: state.uri.queryParameters['userID']!,
        //     id: state.uri.queryParameters['id']!,
        //     createdDateStr: state.uri.queryParameters['createdDateStr']!,
        //     expenceTypeName: state.uri.queryParameters['expenceTypeName'],
        //     expenceDateStr: state.uri.queryParameters['expenceDateStr']!,
        //     priceStr: state.uri.queryParameters['priceStr']!,
        //     col1: state.uri.queryParameters['col1']!,
        //     col2: state.uri.queryParameters['col2']!,
        //     col3: state.uri.queryParameters['col3']!,
        //     taxTypeName: state.uri.queryParameters['taxTypeName'],
        //     invoiceNumber: state.uri.queryParameters['invoiceNumber']!,
        //     reportName: state.uri.queryParameters['reportName']!,
        //   ),
        // ),
        GoRoute(
          name: 'expenceinputfs',
          path: 'expenceinputfs',
          builder: (context, state) => ExpenceInputFs(
              reportID: state.uri.queryParameters['reportID']!,
              userID: state.uri.queryParameters['userID']!,
              id: state.uri.queryParameters['id']!,
              createdDateStr: state.uri.queryParameters['createdDateStr']!,
              expenceTypeName: state.uri.queryParameters['expenceTypeName'],
              expenceDateStr: state.uri.queryParameters['expenceDateStr']!,
              // priceStr: state.uri.queryParameters['priceStr']!,
              priceStr: state.uri.queryParameters['priceStr'] == null
                  ? ""
                  : state.uri.queryParameters['priceStr']!,
              col1: state.uri.queryParameters['col1']!,
              col2: state.uri.queryParameters['col2']!,
              col3: state.uri.queryParameters['col3']!,
              taxTypeName: state.uri.queryParameters['taxTypeName'],
              // invoiceNumber: state.uri.queryParameters['invoiceNumber']!,
              invoiceNumber: state.uri.queryParameters['invoiceNumber'] == null
                  ? ""
                  : state.uri.queryParameters['invoiceNumber']!,
              reportName: state.uri.queryParameters['reportName']!,
              reportStatus: state.uri.queryParameters['status']!),
        ),
        // GoRoute(
        //   name: "expencescreen",
        //   path: "expencescreen",
        //   builder: (context, state) => ExpencesScreen(
        //     reportID: state.uri.queryParameters['reportID']!,
        //     userID: state.uri.queryParameters['userID']!,
        //     reportName: state.uri.queryParameters['reportName']!,
        //   ),
        // ),
        GoRoute(
          name: "expencescreenfs",
          path: "expencescreenfs",
          builder: (context, state) => ExpencesScreenFs(
            reportID: state.uri.queryParameters['reportID']!,
            userID: state.uri.queryParameters['userID']!,
            reportName: state.uri.queryParameters['reportName']!,
            reportStatus: state.uri.queryParameters['reportStatus']!,
          ),
        ),
        // GoRoute(
        //   name: "fbdataadd",
        //   path: "fbdataadd",
        //   builder: (context, state) => const FirebaseAddData(),
        // ),
        GoRoute(
          name: "fbdataget",
          path: "fbdataget",
          builder: (context, state) => const GetSampleData(),
        ),
      ],
    ),
  ],
);
