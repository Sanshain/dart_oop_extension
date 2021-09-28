import 'dart:async';

import 'package:build/build.dart';
import 'package:oop_extension_generator/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:logging/logging.dart';


//Builder constructorGenerator(BuilderOptions options) => ConstructorGenerator();
//Builder metadataLibraryBuilder(BuilderOptions options) => LibraryBuilder(ConstructorGenerator(), generatedExtension: '.info.dart');

Builder constructorGenerator(BuilderOptions options) => SharedPartBuilder([ConstructorGenerator()], 'constructor_generator');

class ConstructorGenerator extends Generator {

    final logger = Logger('ConstructorGenerator');

    @override
    String generate(LibraryReader library, BuildStep buildStep) {

        var result = '';

        var constructorType = const TypeChecker.fromRuntime(Constructor);
        var annotatedTypes = library.annotatedWith(
            constructorType
        );

        var types = library.allElements
            .whereType<ClassElement>()
            .where((cls) => !cls.isEnum && !cls.isAbstract && !cls.isMixin)
            .where((cls) => constructorType.annotationsOf(cls).isNotEmpty);

        if (types.isEmpty) return '';

        // ignore: avoid_print
        print('start generation');

        logger.info(types
//            .where((cls) => annotatedTypes.contains(cls))
//            .where((cls) => cls.constructors.isEmpty)
//            .where((cls) => cls.constructors.isEmpty || annotatedTypes.contains(cls))
            .map((e) => e.name)
            .join(', ')
        );

        for (var cls in types) {

            logger.info('<<<<<${cls.name}>>>>>>>');

            var annotation = constructorType.annotationsOf(cls).first;
//                var ctorName = annotation.getField('name')?.toStringValue() ?? '';
//                var args = cls.fields.map((field) => 'this.' + field.name).join(', ');
            var args = cls.fields.map((field) => '${field.type}? ${field.name}').join(', ');

            var declaration = 'extension ${cls.name}Constructor on ${cls.name}{';
//                var constructor = '    ${cls.name + (ctorName.isEmpty ? '': '.' + ctorName)}($args);';

            var body = cls.fields.map((field) => ' '*8 + 'if (${field.name} != null) this.${field.name} = ${field.name};').join('\n');
            var constructor = '    void _({$args}){\n$body\n    }';

            var closing = '}';

            result += declaration + constructor + closing;
        }

//        final sumNames = topLevelNumVariables(library)
//            .map((element) => element.name)
//            .join(' + ');

        logger.info('result: ${result.length}');

        return result;
    }
}




//class TodoReporterGenerator extends GeneratorForAnnotation<Constructor> {
//    @override
//    FutureOr<String> generateForAnnotatedElement(
//        Element element, ConstantReader annotation, BuildStep buildStep) {
//        return "// Hey! Annotation found!";
//    }
//}




//Iterable<TopLevelVariableElement> topLevelNumVariables(LibraryReader reader) =>
//    reader.allElements.whereType<TopLevelVariableElement>().where((element) =>
//    element.type.isDartCoreNum ||
//        element.type.isDartCoreInt ||
//        element.type.isDartCoreDouble);