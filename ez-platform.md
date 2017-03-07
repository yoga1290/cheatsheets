# eZ platform

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
