@isTest
private class IBMNaturalLanguageClassifierV1Test {

  /**
   *  Test phrase to classify.
   *
   */
  static testMethod void testClassify() {
    String body = IBMWatsonMockResponses.Classify();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMWatsonIAMOptions iamOptions = new IBMWatsonIAMOptions.Builder()
      .apiKey('apikey')
      .build();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1(iamOptions);
    service.setEndPoint('https://gateway.watsonplatform.net/natural-language-classifier/api');
    String classifier_id_serialized_name = '10D41B-nlc-1';
    String text_serialized_name = 'How hot will it be today?';
    // this would be the expected top class as defined on the mock response
    String top_class_serialized_name = 'temperature';
    IBMNaturalLanguageClassifierV1Models.ClassifyOptions classifyOptions = new IBMNaturalLanguageClassifierV1Models.ClassifyOptionsBuilder()
      .classifierId(classifier_id_serialized_name)
      .text(text_serialized_name)
      .build();
    IBMNaturalLanguageClassifierV1Models.Classification classification = service.classify(classifyOptions);
    System.assertEquals(classification.getClassifierId(), classifier_id_serialized_name);
    System.assertEquals(classification.getUrl(), IBMWatsonMockResponses.IBMNaturalLanguageClassifierClassifyURL);
    System.assertEquals(classification.getText(), text_serialized_name);
    System.assertEquals(classification.getTopClass(), top_class_serialized_name);
    List<IBMNaturalLanguageClassifierV1Models.ClassifiedClass> ClassifiedClassList = classification.getClasses();
    System.assertNotEquals(ClassifiedClassList, null);
    System.assertEquals(ClassifiedClassList.size(), 2);
    IBMNaturalLanguageClassifierV1Models.ClassifiedClass ClassifiedClass = ClassifiedClassList[0];
    String class_name_serialized_name = ClassifiedClass.getClassName();
    Set<String> class_name_set = new Set<String>{'temperature', 'conditions'};
    System.assert(class_name_set.contains(class_name_serialized_name), 'Invalid class name for classifier.');
    Double confidence_serialized_name = ClassifiedClass.getConfidence();
    System.assertNotEquals(confidence_serialized_name, null);
    System.assert(confidence_serialized_name > 0, 'Invalid confidence for classifier.');
    IBMNaturalLanguageClassifierV1Models.ClassifyOptionsBuilder ClassifyOptionsBuilder = classifyOptions.newBuilder();
    ClassifyOptionsBuilder = new IBMNaturalLanguageClassifierV1Models.ClassifyOptionsBuilder(classifier_id_serialized_name, text_serialized_name);
    Test.stopTest();
  }

  /**
   * Test classifying multiple phrases at once.
   */
  static testMethod void testClassifyCollection() {
    String body = IBMWatsonMockResponses.ClassifyCollection();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1();
    service.setEndPoint('https://gateway.watsonplatform.net/natural-language-classifier/api');
    service.setUsernameAndPassword('username', 'password');
    String classifierId = '10D41B-nlc-1';
    IBMNaturalLanguageClassifierV1Models.ClassifyInput input1 = new IBMNaturalLanguageClassifierV1Models.ClassifyInput();
    String text1 = 'How hot will it be today?';
    input1.setText(text1);
    IBMNaturalLanguageClassifierV1Models.ClassifyInput input2 = new IBMNaturalLanguageClassifierV1Models.ClassifyInput();
    String text2 = 'Is it hot outside?';
    input2.setText(text2);
    List<IBMNaturalLanguageClassifierV1Models.ClassifyInput> inputCollection = new List<IBMNaturalLanguageClassifierV1Models.ClassifyInput> {
      input1,
      input2
    };
    IBMNaturalLanguageClassifierV1Models.ClassifyCollectionOptions classifyOptions = new IBMNaturalLanguageClassifierV1Models.ClassifyCollectionOptionsBuilder()
      .classifierId(classifierId)
      .collection(inputCollection)
      .build();
    IBMNaturalLanguageClassifierV1Models.ClassificationCollection classification = service.classifyCollection(classifyOptions);
    System.assertEquals(classification.getClassifierId(), classifierId);
    System.assertEquals(classification.getUrl(), 'https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/' + classifierId);
    System.assertEquals(classification.getCollection().get(0).getText(), text1);
    System.assertEquals(classification.getCollection().get(0).getTopClass(), 'temperature');
    System.assertEquals(classification.getCollection().get(1).getText(), text2);
    System.assertEquals(classification.getCollection().get(1).getTopClass(), 'temperature');
    Test.stopTest();
  }

  /**
   *  Test send data to create and train a classifier.
   *
   */
  static testMethod void  testCreateClassifier() {
    String body = IBMWatsonMockResponses.CreateClassifier();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1();
    service.setEndPoint('https://gateway.watsonplatform.net/natural-language-classifier/api');
    service.setUsernameAndPassword('username', 'password');
    Attachment TrainingMetadata = new Attachment(Body = Blob.valueOf('test string'),
      Name='test.txt',
      Description='test description',
      ContentType='text/plain');
    IBMWatsonFile training_metadata_serialized_name = new IBMWatsonFile.FileBuilder()
      .attachment(TrainingMetadata)
      .build();
    Attachment TrainingData = new Attachment(Body = Blob.valueOf('test string'),
      Name='test.txt',
      Description='test description',
      ContentType='text/plain');
    String training_metadata_filename_serialized_name = 'My Classifier Metadata';
    IBMWatsonFile training_data_serialized_name = new IBMWatsonFile.FileBuilder()
      .attachment(TrainingData)
      .build();
    String training_data_filename_serialized_name = 'My Classifier Data';
    IBMNaturalLanguageClassifierV1Models.CreateClassifierOptions createClassifierOptions =
      new IBMNaturalLanguageClassifierV1Models.CreateClassifierOptionsBuilder()
      .trainingMetadata(training_metadata_serialized_name)
      .trainingMetadataFilename(training_metadata_filename_serialized_name)
      .trainingData(training_data_serialized_name)
      .trainingDataFilename(training_data_filename_serialized_name)
      .build();
    IBMNaturalLanguageClassifierV1Models.Classifier Classifier = service.createClassifier(createClassifierOptions);
    System.assertEquals(Classifier.getName(), 'My Classifier');
    System.assertEquals(Classifier.getUrl(), IBMWatsonMockResponses.IBMNaturalLanguageClassifierClassifyBaseURL);
    System.assertEquals(Classifier.getStatus(), 'Training');
    System.assertEquals(Classifier.getClassifierId(), '10D41B-nlc-1');
    System.assertEquals(Classifier.getCreated(), (DateTime)JSON.deserialize('"2015-05-28T18:01:57.393Z"', DateTime.class));
    System.assertEquals(Classifier.getStatusDescription(), 'The classifier instance is in its training phase, not yet ready to accept classify requests');
    System.assertEquals(Classifier.getLanguage(), 'en');
    IBMNaturalLanguageClassifierV1Models.CreateClassifierOptionsBuilder
      CreateClassifierOptionsBuilder = createClassifierOptions.newBuilder();
    CreateClassifierOptionsBuilder = new IBMNaturalLanguageClassifierV1Models.CreateClassifierOptionsBuilder(training_metadata_serialized_name,
     training_data_serialized_name);
    Test.stopTest();
  }

  /**
   *  Test send data to delete a classifier.
   *
   */
  static testMethod void testDeleteClassifier() {
    String body = IBMWatsonMockResponses.CreateClassifier();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1();
    service.setEndPoint('https://gateway.watsonplatform.net/natural-language-classifier/api');
    service.setUsernameAndPassword('username', 'password');
    String classifier_id_serialized_name = '10D41B-nlc-1';
    IBMNaturalLanguageClassifierV1Models.DeleteClassifierOptions deleteClassifierOptions =
      new IBMNaturalLanguageClassifierV1Models.DeleteClassifierOptionsBuilder()
      .classifierId(classifier_id_serialized_name)
      .build();
    service.deleteClassifier(deleteClassifierOptions);
    IBMNaturalLanguageClassifierV1Models.DeleteClassifierOptionsBuilder DeleteClassifierOptionsBuilder =
      deleteClassifierOptions.newBuilder();
    DeleteClassifierOptionsBuilder = new IBMNaturalLanguageClassifierV1Models.DeleteClassifierOptionsBuilder(classifier_id_serialized_name);
    Test.stopTest();
  }

  static testMethod void testGetClassifier() {
    String body = IBMWatsonMockResponses.getClassifier();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1();
    service = new IBMNaturalLanguageClassifierV1('username', 'password');
    String classifier_id_serialized_name = '10D41B-nlc-1';
    service.setEndPoint('https://gateway.watsonplatform.net/natural-language-classifier/api');
    IBMNaturalLanguageClassifierV1Models.GetClassifierOptions getClassifierOption =
      new IBMNaturalLanguageClassifierV1Models.GetClassifierOptionsBuilder()
      .classifierId(classifier_id_serialized_name)
      .build();
    IBMNaturalLanguageClassifierV1Models.Classifier Classifier = service.getClassifier(getClassifierOption);
    System.assertEquals(Classifier.getName(), 'My Classifier');
    System.assertEquals(Classifier.getUrl(), IBMWatsonMockResponses.IBMNaturalLanguageClassifierClassifyBaseURL);
    System.assertEquals(Classifier.getStatus(), 'Available');
    System.assertEquals(Classifier.getClassifierId(), '10D41B-nlc-1');
    System.assertEquals(Classifier.getCreated(), (DateTime)JSON.deserialize('"2015-05-28T18:01:57.393Z"', DateTime.class));
    System.assertEquals(Classifier.getStatusDescription(), 'The classifier instance is now available and is ready to take classifier requests.');
    System.assertEquals(Classifier.getLanguage(), 'en');
    IBMNaturalLanguageClassifierV1Models.GetClassifierOptionsBuilder GetClassifierOptionsBuilder =
      getClassifierOption.newBuilder();
    GetClassifierOptionsBuilder = new IBMNaturalLanguageClassifierV1Models.GetClassifierOptionsBuilder(classifier_id_serialized_name);
    Test.stopTest();
  }

  static testMethod void testListClassifiers() {
    String body = IBMWatsonMockResponses.listClassifiers();
    IBMWatsonMockHttpResponse mockResponse = new IBMWatsonMockHttpResponse(200, 'Success', body, null);
    Test.setMock(HttpCalloutMock.class, mockResponse);
    Test.startTest();
    IBMNaturalLanguageClassifierV1 service = new IBMNaturalLanguageClassifierV1();
    IBMNaturalLanguageClassifierV1Models.ListClassifiersOptions listClassifiersOptions =
      new IBMNaturalLanguageClassifierV1Models.ListClassifiersOptionsBuilder()
      .build();
    IBMNaturalLanguageClassifierV1Models.ClassifierList ClassifierList = service.listClassifiers(listClassifiersOptions);
    List<IBMNaturalLanguageClassifierV1Models.Classifier> Classifiers = ClassifierList.getClassifiers();
    System.assertNotEquals(Classifiers, null);
    System.assertEquals(Classifiers.size(), 1);
    IBMNaturalLanguageClassifierV1Models.Classifier Classifier = Classifiers[0];
    System.assertEquals(Classifier.getName(), 'My Classifier');
    System.assertEquals(Classifier.getUrl(), IBMWatsonMockResponses.IBMNaturalLanguageClassifierClassifyBaseURL);
    System.assertEquals(Classifier.getStatus(), null);
    System.assertEquals(Classifier.getClassifierId(), '10D41B-nlc-1');
    System.assertEquals(Classifier.getCreated(), (DateTime)JSON.deserialize('"2015-05-28T18:01:57.393Z"', DateTime.class));
    System.assertEquals(Classifier.getStatusDescription(), null);
    System.assertEquals(Classifier.getLanguage(), 'en');
    IBMNaturalLanguageClassifierV1Models.ListClassifiersOptionsBuilder ListClassifiersOptionsBuilder =
      listClassifiersOptions.newBuilder();
    Test.stopTest();
  }

}