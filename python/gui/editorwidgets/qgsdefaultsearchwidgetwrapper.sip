/************************************************************************
 * This file has been generated automatically from                      *
 *                                                                      *
 * src/gui/editorwidgets/qgsdefaultsearchwidgetwrapper.h                *
 *                                                                      *
 * Do not edit manually ! Edit header and run scripts/sipify.pl again   *
 ************************************************************************/





class QgsDefaultSearchWidgetWrapper : QgsSearchWidgetWrapper
{
%Docstring
 Wraps a search widget. Default form is just a QgsLineFilterEdit
%End

%TypeHeaderCode
#include "qgsdefaultsearchwidgetwrapper.h"
%End
  public:
    explicit QgsDefaultSearchWidgetWrapper( QgsVectorLayer *vl, int fieldIdx, QWidget *parent /TransferThis/ = 0 );

  public:
    virtual QString expression();

    virtual bool applyDirectly();

    virtual QgsSearchWidgetWrapper::FilterFlags supportedFlags() const;

    virtual QgsSearchWidgetWrapper::FilterFlags defaultFlags() const;

    virtual QString createExpression( QgsSearchWidgetWrapper::FilterFlags flags ) const;

  public slots:

    virtual void clearWidget();

    virtual void setEnabled( bool enabled );

  protected slots:
    virtual void setExpression( QString exp );


  protected:
    virtual QWidget *createWidget( QWidget *parent );

    virtual void initWidget( QWidget *editor );

    virtual bool valid() const;


    QgsFilterLineEdit *lineEdit();
%Docstring
 Returns a pointer to the line edit part of the widget.
.. note::

   this method is in place for unit testing only, and is not considered
 stable API
 :rtype: QgsFilterLineEdit
%End

    QCheckBox *caseSensitiveCheckBox();
%Docstring
 Returns a pointer to the case sensitivity checkbox in the widget.
.. note::

   this method is in place for unit testing only, and is not considered
 stable API
 :rtype: QCheckBox
%End

};

/************************************************************************
 * This file has been generated automatically from                      *
 *                                                                      *
 * src/gui/editorwidgets/qgsdefaultsearchwidgetwrapper.h                *
 *                                                                      *
 * Do not edit manually ! Edit header and run scripts/sipify.pl again   *
 ************************************************************************/
