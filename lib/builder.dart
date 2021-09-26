import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:analyzer/dart/element/element.dart';


//Builder constructorGenerator(BuilderOptions options) => ConstructorGenerator();
//Builder metadataLibraryBuilder(BuilderOptions options) => LibraryBuilder(ConstructorGenerator(), generatedExtension: '.info.dart');

Builder constructorGenerator(BuilderOptions options) => SharedPartBuilder([ConstructorGenerator()], 'constructor_generator');

class ConstructorGenerator extends Generator {
    @override
    String generate(LibraryReader library, BuildStep buildStep) {

        print('-----------');
        final sumNames = topLevelNumVariables(library)
            .map((element) => element.name)
            .join(' + ');

        return '''num allSum() => $sumNames;''';
    }
}

Iterable<TopLevelVariableElement> topLevelNumVariables(LibraryReader reader) =>
    reader.allElements.whereType<TopLevelVariableElement>().where((element) =>
    element.type.isDartCoreNum ||
        element.type.isDartCoreInt ||
        element.type.isDartCoreDouble);