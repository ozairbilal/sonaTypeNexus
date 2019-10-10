import org.sonatype.nexus.repository.storage.Component
import org.sonatype.nexus.repository.storage.Query
import org.sonatype.nexus.repository.storage.StorageFacet

log.info("delete components for repository: maven-releases")

def compInfo = { Component c -> "${c.group()}:${c.name()}:${c.version()}[${c.lastUpdated()}]}" }
def repo = repository.repositoryManager.get("maven-releases")
StorageFacet storageFacet = repo.facet(StorageFacet)
def tx = storageFacet.txSupplier().get()
tx.begin()
Iterable<Component> components = tx.findComponents(Query.builder().where('group = ').param('upload').and('name = ').param('vision').and('version like').param('%develop%').build(), [repo])
tx.commit()
tx.close()
log.info("about to delete " + components.flatten(compInfo))
for(Component c : components) {
    log.info("deleting " + compInfo(c))
	tx2 = storageFacet.txSupplier().get()
    tx2.begin()
    tx2.deleteComponent(c)
    tx2.commit()
    tx2.close()
}
log.info("finished deleting " + components.flatten(compInfo))
