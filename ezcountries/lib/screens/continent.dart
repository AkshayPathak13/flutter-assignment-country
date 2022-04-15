import 'package:ezcountries/arguments/country_arguments.dart';
import 'package:ezcountries/blocs/continent/continent.dart';
import 'package:ezcountries/screens/country.dart';
import 'package:ezcountries/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContinentScreen extends StatelessWidget {
  final String title = 'All Continents';
  const ContinentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContinentBloc>(
      create: ((context) =>
          ContinentBloc(countryService: Singleton.countryService)),
      child: BlocBuilder<ContinentBloc, ContinentState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: body(context, state));
        },
      ),
    );
  }

  Widget body(BuildContext context, ContinentState state) {
    switch (state.runtimeType) {
      case Initial:
        context.read<ContinentBloc>().add(LoadContinents());
        return const Center(child: CircularProgressIndicator());
      case LoadingContinents:
        return const Center(child: CircularProgressIndicator());
      case FailedToLoadContinents:
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to fetch data'),
            IconButton(
                onPressed: () {
                  context.read<ContinentBloc>().add(LoadContinents());
                },
                icon: const Icon(Icons.refresh))
          ],
        ));
      case LoadedContinents:
        return ListView.builder(
            itemCount: (state as LoadedContinents).continents.length,
            itemBuilder: ((context, index) {
              var continent = state.continents[index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, CountryScreen.route,
                      arguments: CountryArguments(
                        continentName: continent.name!,
                        continentCode: continent.code!,
                      ));
                },
                title: Text(continent.name ?? ''),
                subtitle: Text(continent.code ?? ''),
                trailing: const Icon(Icons.arrow_right),
              );
            }));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
