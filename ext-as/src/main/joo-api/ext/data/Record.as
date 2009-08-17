package ext.data {
import ext.util.MixedCollection;

/**
 * <p>Instances of this class encapsulate both Record <em>definition</em> information, and Record
 * <em>value</em> information for use in <b class='link'>ext.data.Store</b> objects, or any code which needs
 * to access Records cached in an <b class='link'>ext.data.Store</b> object.</p>
 * <p>Constructors for this class are generated by passing an Array of field definition objects to <b class='link'>#create</b>.
 * Instances are usually only created by <b class='link'>ext.data.Reader</b> implementations when processing unformatted data
 * objects.</p>
 * <p>Note that an instance of a Record class may only belong to one <b class='link' title='ext.data.Store'>Store</b> at a time.
 * In order to copy data from one Store to another, use the <b class='link'>#copy</b> method to create an exact
 * copy of the Record, and insert the new instance into the other Store.</p>
 * <p>When serializing a Record for submission to the server, be aware that it contains many private
 * properties, and also a reference to its owning Store which in turn holds references to its Records.
 * This means that a whole Record may not be encoded using <b class='link'>Ext.util.JSON.encode</b>. Instead, use the
 * <code><b class='link'>#data</b></code> and <code><b class='link'>#id</b></code> properties.</p>
 * <p>Record objects generated by this constructor inherit all the methods of ext.data.Record listed below.</p>
*/
public class Record {
/**
 * @constructor
 * This constructor should not be used to create Record objects. Instead, use <b class='link'>#create</b> to
 * generate a subclass of ext.data.Record configured with information about its constituent fields.
 * @param data An object, the properties of which provide values for the new Record's
 * fields. If not specified the <code><b class='link' title='ext.data.Field#defaultValue'>defaultValue</b></code>
 * for each field will be assigned.
 * @param id The id of the Record. This id should be unique, and is used by the
 * <b class='link'>ext.data.Store</b> object which owns the Record to index its collection of Records. If
 * an <code>id</code> is not specified a <b><code><b class='link'>#phantom</b></code></b> Record will be created
 * with an <b class='link' title='#Record.id automatically generated'>id</b>.
 */
public function Record(data : Object = undefined, id : Object = undefined) {
  super(data, id);
}
/**
 * Generate a constructor for a specific Record layout.
 * @param o An Array of <b class='link' title='ext.data.Field'>Field</b> definition objects.
 * The constructor generated by this method may be used to create new Record instances. The data
 * object must contain properties named after the <b class='link' title='ext.data.Field'>field</b>
 * <b><tt><b class='link'>ext.data.Field#name</b>s</tt></b>.  Example usage:<pre><code>
// create a Record constructor from a description of the fields
var TopicRecord = ext.data.Record.create([ // creates a subclass of ext.data.Record
    {<b class='link' title='ext.data.Field#name'>name</b>: 'title', <b class='link' title='ext.data.Field#mapping mapping}:'>'topic_title'</b>,
    {name: 'author', mapping: 'username', allowBlank: false},
    {name: 'totalPosts', mapping: 'topic_replies', type: 'int'},
    {name: 'lastPost', mapping: 'post_time', type: 'date'},
    {name: 'lastPoster', mapping: 'user2'},
    {name: 'excerpt', mapping: 'post_text', allowBlank: false},
    // In the simplest case, if no properties other than <tt>name</tt> are required,
    // a field definition may consist of just a String for the field name.
    'signature'
]);

// create Record instance
var myNewRecord = new TopicRecord(
    {
        title: 'Do my job please',
        author: 'noobie',
        totalPosts: 1,
        lastPost: new Date(),
        lastPoster: 'Animal',
        excerpt: 'No way dude!',
        signature: ''
    },
    id // optionally specify the id of the record otherwise <b class='link' title='#Record.id one is'>auto-assigned</b>
);
myStore.<b class='link' title='ext.data.Store#add'>add</b>(myNewRecord);
</code></pre>
 * @method create
 * @return A constructor which is used to create new Records according
 * to the definition. The constructor has the same signature as <b class='link'>#ext.data.Record</b>.
 * @static
 */
public native function create (o : Array) : Function;
public static var PREFIX : String = 'ext-record';
public static var AUTO_ID : String = "1";
public static var EDIT : String = 'edit';
public static var REJECT : String = 'reject';
public static var COMMIT : String = 'commit';
/**
 * Generates a sequential id. This method is typically called when a record is <b class='link'>#create</b>d
 * and <b class='link' title='#Record no id has been'>specified</b>. The returned id takes the form:
 * <tt>&#123;PREFIX}-&#123;AUTO_ID}</tt>.<div class="mdetail-params"><ul>
 * <li><b><tt>PREFIX</tt></b> : String<p class="sub-desc"><tt>ext.data.Record.PREFIX</tt>
 * (defaults to <tt>'ext-record'</tt>)</p></li>
 * <li><b><tt>AUTO_ID</tt></b> : String<p class="sub-desc"><tt>ext.data.Record.AUTO_ID</tt>
 * (defaults to <tt>1</tt> initially)</p></li>
 * </ul></div>
 * @param rec The record being created.  The record does not exist, it's a <b class='link'>#phantom</b>.
 * @return auto-generated string id, <tt>"ext-record-i++'</tt>;
 */
public native function id (rec : Record) : String;
    /**
     * <p><b>This property is stored in the Record definition's <u>prototype</u></b></p>
     * A MixedCollection containing the defined <b class='link' title='ext.data.Field'>Field</b>s for this Record.  Read-only.
     * @property fields
     */
  public var fields : MixedCollection;
    /**
     * An object hash representing the data for this Record. Every field name in the Record definition
     * is represented by a property of that name in this object. Note that unless you specified a field
     * with <b class='link' title='ext.data.Field#name'>name</b> "id" in the Record definition, this will <b>not</b> contain
     * an <tt>id</tt> property.
     * @property data
     */
  public var data : Object;
    /**
     * The unique ID of the Record <b class='link' title='#Record as specified at construction'>time</b>.
     * @property id
     */
    /**
     * Readonly flag - true if this Record has been modified.
     */
    public var dirty  : Boolean;
    public var editing ;
    public var error;
    /**
     * This object contains a key and value storing the original values of all modified
     * fields or is null if no fields have been modified.
     * @property modified
     */
    public var modified : Object;
    /**
     * <tt>false</tt> when the record does not yet exist in a server-side database (see
     * <b class='link'>#markDirty</b>).  Any record which has a real database pk set as its id property
     * is NOT a phantom -- it's real.
     * @property phantom
     */
    public var phantom  : Boolean;
    protected native function join(store) : void;
        /**
         * The <b class='link'>ext.data.Store</b> to which this Record belongs.
         * @property store
         */
    /**
     * Set the <b class='link' title='ext.data.Field#name named'>field</b> to the specified value.  For example:
     * <pre><code>
// record has a field named 'firstname'
var Employee = ext.data.Record.<b class='link'>#create</b>([
    {name: 'firstname'},
    ...
]);

// update the 2nd record in the store:
var rec = myStore.<b class='link' title='ext.data.Store#getAt'>getAt</b>(1);

// set the value (shows dirty flag):
rec.set('firstname', 'Betty');

// commit the change (removes dirty flag):
rec.<b class='link'>#commit</b>();

// update the record in the store, bypass setting dirty flag,
// and do not store the change in the <b class='link' title='ext.data.Store#getModifiedRecords modified'>records</b>
rec.<b class='link'>#data</b>['firstname'] = 'Wilma'); // updates record, but not the view
rec.<b class='link'>#commit</b>(); // updates the view
     * </code></pre>
     * <b>Notes</b>:<div class="mdetail-params"><ul>
     * <li>If the store has a writer and <code>autoSave=true</code>, each set()
     * will execute an XHR to the server.</li>
     * <li>Use <code><b class='link'>#beginEdit</b></code> to prevent the store's <code>update</code>
     * event firing while using set().</li>
     * <li>Use <code><b class='link'>#endEdit</b></code> to have the store's <code>update</code>
     * event fire.</li>
     * </ul></div>
     * @param name The <b class='link' title='ext.data.Field#name name of the'>field</b> to set.
     * @param value The value to set the field to.
     */
    public native function set(name : String, value : Object) : void;
    protected native function afterEdit() : void;
    protected native function afterReject() : void;
    protected native function afterCommit() : void;
    /**
     * Get the value of the <b class='link' title='ext.data.Field#name named'>field</b>.
     * @param name The <b class='link' title='ext.data.Field#name name of the'>field</b> to get the value of.
     * @return The value of the field.
     */
    public native function get(name : String) : Object;
    /**
     * Begin an edit. While in edit mode, no events (e.g.. the <code>update</code> event)
     * are relayed to the containing store.
     * See also: <code><b class='link'>#endEdit</b></code> and <code><b class='link'>#cancelEdit</b></code>.
     */
    public native function beginEdit() : void;
    /**
     * Cancels all changes made in the current edit operation.
     */
    public native function cancelEdit() : void;
    /**
     * End an edit. If any data was modified, the containing store is notified
     * (ie, the store's <code>update</code> event will fire).
     */
    public native function endEdit() : void;
    /**
     * Usually called by the <b class='link'>ext.data.Store</b> which owns the Record.
     * Rejects all changes made to the Record since either creation, or the last commit operation.
     * Modified fields are reverted to their original values.
     * <p>Developers should subscribe to the <b class='link'>ext.data.Store#update</b> event
     * to have their code notified of reject operations.</p>
     * @param silent True to skip notification of the owning
     * store of the change (defaults to false)
     */
    public native function reject(silent : Boolean = undefined) : void;
    /**
     * Usually called by the <b class='link'>ext.data.Store</b> which owns the Record.
     * Commits all changes made to the Record since either creation, or the last commit operation.
     * <p>Developers should subscribe to the <b class='link'>ext.data.Store#update</b> event
     * to have their code notified of commit operations.</p>
     * @param silent True to skip notification of the owning
     * store of the change (defaults to false)
     */
    public native function commit(silent : Boolean = undefined) : void;
    /**
     * Gets a hash of only the fields that have been modified since this Record was created or commited.
     * @return 
     */
    public native function getChanges() : Object;
    protected native function hasError() : void;
    protected native function clearError() : void;
    /**
     * Creates a copy of this Record.
     * @param id A new Record id, defaults to <b class='link' title='#Record.id autogenerating an'>id</b>.
     * Note: if an <code>id</code> is not specified the copy created will be a
     * <code><b class='link'>#phantom</b></code> Record.
     * @return 
     */
    public native function copy(id : String = undefined) : Record;
    /**
     * Returns <tt>true</tt> if the passed field name has been <code><b class='link'>#modified</b></code>
     * since the load or last commit.
     * @param fieldName see <b class='link'>ext.data.Field.</b><b class='link'>ext.data.Field#name</b>
     * @return 
     */
    public native function isModified(fieldName : String) : Boolean;
    /**
     * By default returns <tt>false</tt> if any <b class='link' title='ext.data.Field'>field</b> within the
     * record configured with <tt><b class='link'>ext.data.Field#allowBlank</b> = false</tt> returns
     * <tt>true</tt> from an <b class='link'>Ext</b>.<b class='link' title='Ext#isEmpty'>isempty</b> test.
     * @return 
     */
    public native function isValid() : Boolean;
    /**
     * <p>Marks this <b>Record</b> as <code><b class='link'>#dirty</b></code>.  This method
     * is used interally when adding <code><b class='link'>#phantom</b></code> records to a
     * <b class='link' title='ext.data.Store#writer writer enabled'>store</b>.</p>
     * <br><p>Marking a record <code><b class='link'>#dirty</b></code> causes the phantom to
     * be returned by <b class='link'>ext.data.Store#getModifiedRecords</b> where it will
     * have a create action composed for it during <b class='link' title='ext.data.Store#save store'>save</b>
     * operations.</p>
     */
    public native function markDirty() : void;

    protected var store : Store;
}}
