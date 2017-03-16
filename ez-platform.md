# eZ platform

# View

+ [`{{ ez_render_field( content, 'some_field_identifier' ) }}`](https://doc.ez.no/display/DEVELOPER/Content+Rendering#ContentRendering-UsingtheFieldType'stemplateblock)
+ [`{{ ez_field_value( content, 'some_field_identifier' ) }}`](https://doc.ez.no/display/DEVELOPER/Content+Rendering#ContentRendering-GettingrawFieldvalue)



# Controller

## [Creating a JSON Response](http://symfony.com/doc/current/components/http_foundation.html#creating-a-json-response)

```php
use Symfony\Component\HttpFoundation\Response;

$response = new Response();
$response->setContent(json_encode(array(
    'data' => 123,
)));
$response->headers->set('Content-Type', 'application/json');
```

## Search

### Criterion


```
$criterionArray = array(
    new \eZ\Publish\API\Repository\Values\Content\Query\Criterion\ContentTypeIdentifier( $contentTypeIdentifiers ),


    new \eZ\Publish\API\Repository\Values\Content\Query\Criterion\FieldRelation(
                "$FieldIdentifier",
                \eZ\Publish\API\Repository\Values\Content\Query\Criterion\Operator::IN,
                 array("")
    ),

    new \eZ\Publish\API\Repository\Values\Content\Query\Criterion\LanguageCode(
                array("eng-GB")
    ),
    // ...
)
```

### Execute Query:

```
// from Command:
$repository = $this->getContainer()->get( 'ezpublish.api.repository' );
$searchService = $repository->getSearchService();

// from Controller:
$searchService = $this->getRepository()->getSearchService();

$query = new \eZ\Publish\API\Repository\Values\Content\Query();
$query->sortClauses = $sortMethodsArray;
$query->limit = 20;
$query->offset = 0;
$query->query = new \eZ\Publish\API\Repository\Values\Content\Query\Criterion\LogicalAnd($criterionArray);
$result = $searchService->findContent($query)->searchHits;
foreach ($result as $record) {
    $contentTypeId = $record->valueObject->versionInfo->contentInfo->contentTypeId;
    $remoteId = $record->valueObject->versionInfo->contentInfo->remoteId;
    //$identifier = $contentTypeService->loadContentType($contentTypeId)->identifier;
}
```


### Ref
+ [search cheatsheet](http://share.ez.no/blogs/thiago-campos-viana/ez-publish-5-tip-search-cheat-sheet)
+ [eZ| Search](https://doc.ez.no/display/DEVELOPER/Search)
+ [eZ| Content Rendering using QueryTypes from PHP code](https://doc.ez.no/display/DEVELOPER/Content+Rendering#ContentRendering-UsingQueryTypesfromPHPcode)
