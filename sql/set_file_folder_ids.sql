UPDATE photos.files AS f1
INNER JOIN photos.folders AS f2
ON (f1.folder_path = f2.folder_path)
SET f1.folder_id = f2.id
WHERE f1.folder_id IS NULL;
