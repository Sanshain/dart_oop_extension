class Constructor
{
    const Constructor({this.name}): assert(name == null || name.length != 0);
    final String? name;
}

const constructor = Constructor();


class AutoProps{
    const AutoProps({this.prefix = 's_'}) : assert(prefix.length != 0);
    final String prefix;
}

const autoProps = AutoProps();