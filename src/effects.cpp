/* Webcamod, webcam capture plasmoid.
 * Copyright (C) 2011-2012  Gonzalo Exequiel Pedone
 *
 * Webcamod is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamod is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamod. If not, see <http://www.gnu.org/licenses/>.
 *
 * Email     : hipersayan DOT x AT gmail DOT com
 * Web-Site 1: http://github.com/hipersayanX/Webcamoid
 * Web-Site 2: http://kde-apps.org/content/show.php/Webcamoid?content=144796
 */

#include "effects.h"

Effects::Effects(MediaTools *mediaTools, QWidget *parent): QWidget(parent)
{
    this->m_appEnvironment = new AppEnvironment(this);

    this->setupUi(this);

    this->m_mediaTools = mediaTools? mediaTools: new MediaTools(true, this);

    QObject::connect(this->m_mediaTools,
                     SIGNAL(deviceChanged(QString)),
                     this,
                     SLOT(deviceChanged(QString)));

    QMap<QString, QString> effects = this->m_mediaTools->availableEffects();

    foreach (QString effect, effects.keys())
    {
        QListWidgetItem *listWidgetItem = new QListWidgetItem(effects[effect]);

        this->m_effectsNames << effect;
        this->m_effectsWidgets << listWidgetItem;
        this->lswEffects->addItem(listWidgetItem);
    }

    this->lswEffects->sortItems();

    foreach (QString effect, this->m_mediaTools->currentEffects())
    {
        int index = this->m_effectsNames.indexOf(effect);

        if (index < 0)
            continue;

        QListWidgetItem *listWidgetItem = this->lswEffects->takeItem(this->lswEffects->row(this->m_effectsWidgets[index]));
        this->lswApply->addItem(listWidgetItem);
    }
}

void Effects::update()
{
   if (!this->m_mediaTools)
       return;

   QStringList effects;

   for (int i = 0; i < this->lswApply->count(); i++)
   {
       int index = this->m_effectsWidgets.indexOf(this->lswApply->item(i));

       effects << this->m_effectsNames[index];
   }

   this->m_mediaTools->setEffects(effects);
}

void Effects::showEvent(QShowEvent *event)
{
    QWidget::showEvent(event);

    this->m_mediaTools->setEffectsPreview(true);
}

void Effects::hideEvent(QHideEvent *event)
{
    QWidget::hideEvent(event);

    this->m_mediaTools->resetEffectsPreview();
}

void Effects::setEffectPreview(const QImage &image, QString effect)
{
    if (!this->m_mediaTools->device().isEmpty())
    {
        int index = this->m_effectsNames.indexOf(effect);
        this->m_effectsWidgets[index]->setIcon(QIcon(QPixmap::fromImage(image)));
    }
}

void Effects::deviceChanged(QString device)
{
    if (device.isEmpty())
        foreach (QListWidgetItem *effectWidget, this->m_effectsWidgets)
            effectWidget->setIcon(QIcon());
}

void Effects::on_txtSearch_textChanged(QString text)
{
    QRegExp regexp(text, Qt::CaseInsensitive, QRegExp::Wildcard);

    for (int i = 0; i < this->lswEffects->count(); i++)
        if (regexp.indexIn(this->lswEffects->item(i)->text()) == -1)
            this->lswEffects->item(i)->setHidden(true);
        else
            this->lswEffects->item(i)->setHidden(false);

    for (int i = 0; i < this->lswApply->count(); i++)
        if (regexp.indexIn(this->lswApply->item(i)->text()) == -1)
            this->lswApply->item(i)->setHidden(true);
        else
            this->lswApply->item(i)->setHidden(false);
}

void Effects::on_btnAdd_clicked()
{
    foreach (QListWidgetItem *item, this->lswEffects->selectedItems())
        this->lswApply->addItem(this->lswEffects->
                                        takeItem(this->lswEffects->row(item)));

    this->update();
}

void Effects::on_btnRemove_clicked()
{
    foreach (QListWidgetItem *item, this->lswApply->selectedItems())
        this->lswEffects->addItem(this->lswApply->
                                        takeItem(this->lswApply->row(item)));

    this->lswEffects->sortItems();
    this->update();
}

void Effects::on_btnUp_clicked()
{
    foreach (QListWidgetItem *item, this->lswApply->selectedItems())
    {
        int row = this->lswApply->row(item);
        int row_ = (row >= 1)? row - 1: 0;
        QListWidgetItem *item_ = this->lswApply->takeItem(row);
        this->lswApply->insertItem(row_, item_);
        item_->setSelected(true);
    }

    this->update();
}

void Effects::on_btnDown_clicked()
{
    foreach (QListWidgetItem *item, this->lswApply->selectedItems())
    {
        int row = this->lswApply->row(item);
        int row_ = (row < this->lswApply->count() - 1)? row + 1: this->lswApply->count() - 1;
        QListWidgetItem *item_ = this->lswApply->takeItem(row);
        this->lswApply->insertItem(row_, item_);
        item_->setSelected(true);
    }

    this->update();
}

void Effects::on_btnReset_clicked()
{
    while (this->lswApply->count() > 0)
        this->lswEffects->addItem(this->lswApply->takeItem(0));

    this->lswEffects->sortItems();
    this->update();
}