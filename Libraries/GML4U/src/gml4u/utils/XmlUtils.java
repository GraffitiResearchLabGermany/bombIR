package gml4u.utils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;

public class XmlUtils {

	private static final Logger LOGGER = Logger.getLogger(XmlUtils.class.getName());

	/**
	 * Gets Document as a String
	 * @param document
	 * @return provided document as a XML String
	 * @throws TransformerFactoryConfigurationError 
	 * @throws TransformerException 
	 */
	public static String getString(final Document document) throws TransformerFactoryConfigurationError, TransformerException {
		LOGGER.debug("Start creating String from Gml");
		StringWriter stringWriter = new StringWriter();
		Transformer serializer;
		serializer = TransformerFactory.newInstance().newTransformer();
		serializer.transform(new DOMSource(document), new StreamResult(stringWriter));
		LOGGER.debug("Finished creating String from Gml");
		return stringWriter.toString();
	}

	/**
	 * Saves the document to the provided path
	 * @param document
	 * @param filename (can be path and filename)
	 * @throws IOException
	 */
	public static void saveDocument(final Document document, final String filename) throws IOException {
		LOGGER.debug("Start writing file "+filename);
		OutputFormat format = new OutputFormat(document);
		format.setIndenting(true);

		XMLSerializer serializer = new XMLSerializer(new FileOutputStream(new File(filename)), format);
		serializer.serialize(document);
		LOGGER.debug("Finished writing file "+filename);
	}

	/**
	 * Creates a document
	 * @return Document
	 * @throws ParserConfigurationException
	 */
	public static Document createDocument() throws ParserConfigurationException {
		DocumentBuilderFactory factory = DocumentBuilderFactory .newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document document = builder.newDocument();
		return document;
	}
}
