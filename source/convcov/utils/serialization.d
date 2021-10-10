module convcov.utils.serialization;

import asdf.serialization;

/**
 * Array wrapper to make null arrays serializable as empty arrays
 */
struct SerializableArray(T)
{
	/// Array data
	public T[] data;
	alias data this;

	/**
	 * Constructs a serializable array from a given normal array
	 *
	 * Params:
	 *   data = array to wrap
	 */
	this(T[] data)
	{
		this.data = data;
	}

	/**
	 * Custom array serializer for asdf
	 *
	 * Params:
	 *   serializer = JSON serializer
	 */
	void serialize(S)(ref S serializer) const
	{
		auto valState = serializer.arrayBegin();
		foreach (ref elem; data)
		{
			serializer.elemBegin;
			serializer.serializeValue(elem);
		}
		serializer.arrayEnd(valState);
	}
}

/**
 * Appender wrapper to make it act as normal arrays
 */
struct SerializableAppender(T)
{
	import std.array : Appender, appender;

	/// Appender data
	public Appender!(T) data;
	alias data this;

	/**
	 * Constructs a serializable array from a given normal array
	 *
	 * Params:
	 *   data = array to wrap
	 */
	this(T data)
	{
		this.data = appender!T(data);
	}

	this(Appender!T data)
	{
		this.data = data;
	}

	/**
	 * Custom array serializer for asdf
	 *
	 * Params:
	 *   serializer = JSON serializer
	 */
	void serialize(S)(ref S serializer) const
	{
		auto valState = serializer.arrayBegin();
		foreach (ref elem; data[])
		{
			serializer.elemBegin;
			serializer.serializeValue(elem);
		}
		serializer.arrayEnd(valState);
	}
}

pure
unittest
{
	immutable SerializableArray!int b;

	assert(b == []);
	assert("[]" == b.serializeToJson!());
}
