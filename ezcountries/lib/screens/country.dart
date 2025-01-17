import 'dart:async';

import 'package:ezcountries/arguments/country_arguments.dart';
import 'package:ezcountries/models/country_model.dart';
import 'package:ezcountries/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/country/country.dart';

class CountryScreen extends StatefulWidget {
  static const String route = '/CountryRoute';
  const CountryScreen({Key? key}) : super(key: key);

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final TextEditingController textEditingController = TextEditingController();
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CountryArguments;
    return BlocProvider<CountryBloc>(
        create: (context) =>
            CountryBloc(countryService: Singleton.countryService),
        lazy: false,
        child: BlocBuilder<CountryBloc, CountryStates>(
          builder: (context, CountryStates state) {
            return Scaffold(
                appBar: AppBar(
                    title: TextField(
                      controller: textEditingController,
                      onChanged: (text) {
                        if (state.runtimeType == LoadedCountries) {
                          searchTextUpdated(
                              text, context, state as LoadedCountries);
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                    ),
                    titleSpacing: 0,
                    actions: [
                      if (state.runtimeType == LoadedCountries)
                        Builder(
                            builder: (context) => TextButton(
                                onPressed: () {
                                  var loadedCountries =
                                      state as LoadedCountries;
                                  Scaffold.of(context).showBottomSheet((ctx) {
                                    return FilterLanguage(
                                      languages: loadedCountries.languages,
                                      callback: (updatedLanguages) {
                                        ctx.read<CountryBloc>().add(
                                            ReloadCountries(
                                                countries:
                                                    loadedCountries.countries,
                                                languages: updatedLanguages,
                                                searchText: loadedCountries
                                                    .searchText));
                                      },
                                    );
                                  });
                                },
                                child: const Text(
                                  'Filter Languages',
                                  style: TextStyle(color: Colors.black),
                                )))
                    ]),
                body: body(context, state, args.continentCode));
          },
        ));
  }

  Widget body(
      BuildContext context, CountryStates countryStates, String continentCode) {
    switch (countryStates.runtimeType) {
      case Initial:
        context
            .read<CountryBloc>()
            .add(LoadCountries(continentCode: continentCode));
        return const Center(child: CircularProgressIndicator());
      case LoadingCountries:
        return const Center(child: CircularProgressIndicator());
      case LoadedCountries:
        LoadedCountries loadedCountries = countryStates as LoadedCountries;
        List<CountryModel> countries = loadedCountries.countries;
        if (loadedCountries.searchText.isNotEmpty) {
          countries = loadedCountries.countries
              .where((element) => element.code == loadedCountries.searchText)
              .toList();
        }
        if (countries.isEmpty) {
          return const Center(
              child: Text('No Country found with the searched code'));
        }
        return ListView.builder(
            itemCount: countries.length,
            itemBuilder: ((context, index) {
              var country = countries[index];
              if ((loadedCountries.languages[country.native!] ?? true)) {
                return ListTile(
                  onTap: () {},
                  title: Text(country.name ?? ''),
                  subtitle: Text(country.code ?? ''),
                  trailing: const Icon(Icons.arrow_right),
                );
              }
              return const SizedBox(height: 0, width: 0);
            }));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  void searchTextUpdated(
      String? text, BuildContext context, LoadedCountries loadedCountries) {
    if (timer != null) {
      timer?.cancel();
    }
    timer = Timer(const Duration(seconds: 2), () {
      context.read<CountryBloc>().add(ReloadCountries(
          countries: loadedCountries.countries,
          languages: loadedCountries.languages,
          searchText: text!));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    textEditingController.dispose();
    super.dispose();
  }
}

class FilterLanguage extends StatefulWidget {
  final Map<String, bool> languages;
  final Function(Map<String, bool> updatedList) callback;
  const FilterLanguage(
      {Key? key, required this.languages, required this.callback})
      : super(key: key);

  @override
  State<FilterLanguage> createState() => _FilterLanguageState();
}

class _FilterLanguageState extends State<FilterLanguage> {
  @override
  void initState() {
    super.initState();
    languagePreference = widget.languages;
  }

  late Map<String, bool> languagePreference;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Container(
        height: constraints.maxHeight * 0.6,
        width: constraints.maxWidth,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: languagePreference.length,
                  itemBuilder: (context, index) {
                    MapEntry entry =
                        languagePreference.entries.elementAt(index);
                    return CheckboxListTile(
                        value: entry.value,
                        title: Text(entry.key),
                        onChanged: (value) async {
                          setState(() {
                            languagePreference[entry.key] = value!;
                          });
                        });
                  }),
            ),
            ElevatedButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
                widget.callback(languagePreference);
              },
            )
          ],
        ),
      );
    }));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
